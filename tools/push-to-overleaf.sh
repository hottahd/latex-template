#!/bin/sh
# このリポジトリの内容を、研究室 Overleaf のテンプレート用プロジェクトに送る。
#
#   ./tools/push-to-overleaf.sh thesis            送る
#   ./tools/push-to-overleaf.sh thesis --dry-run  何が変わるか見るだけ
#
# 流れは「git が管理しているファイルだけを、Overleaf 側の git に上書きコミットする」
# の一方向です。**正本はこのリポジトリ**で、Overleaf 側は写しです。
# Overleaf の画面で直接編集したものは、次に送ったときに消えます。
#
# 接続先（プロジェクト ID と Overleaf のアドレス）は、このリポジトリではなく
#     ~/.config/latex-template/overleaf.conf
# に置きます。リポジトリを public にしても学内のアドレスが漏れないようにするためです。
# 初回に実行すると、書き方を入れた雛形を作ります。
#
# 認証は Overleaf の Git トークンです。
# トークンは Overleaf の Account Settings で発行します（一度しか表示されません）。
#
# macOS のキーチェーンは、GUI のセッション以外から読み書きしようとすると
#     failed to get: -25308 / failed to store: -25308
# を返して失敗します（エディタや自動化ツールの中で開いたシェルなど）。
# Terminal.app から実行すれば通ります。どこからでも動かしたいなら
# ~/.netrc に書いておくのが確実です。
#
#     printf 'machine <Overleaf のホスト>\n  login git\n  password <トークン>\n' >> ~/.netrc
#     chmod 600 ~/.netrc

set -eu

# 注意: 日本語の直後に変数を置くときは必ず ${var} と波括弧を付けること。
# macOS の /bin/sh (bash 3.2) は "$sha）" の全角括弧の 1 バイト目を
# 変数名の一部と解釈して、set -u で unbound variable になる。

root=$(cd "$(dirname "$0")/.." && pwd)
conf="${XDG_CONFIG_HOME:-$HOME/.config}/latex-template/overleaf.conf"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/latex-template"

name="${1:-}"
dry=0
[ "${2:-}" = "--dry-run" ] && dry=1

if [ -z "$name" ]; then
  echo "使い方: $0 <テンプレート名> [--dry-run]" >&2
  echo "  例: $0 thesis" >&2
  exit 2
fi

if [ ! -d "$root/$name" ]; then
  echo "$name というテンプレートはありません（$root にあるのは thesis / exam / note）" >&2
  exit 2
fi

# ---- 接続先の設定 ---------------------------------------------------------
if [ ! -f "$conf" ]; then
  mkdir -p "$(dirname "$conf")"
  cat > "$conf" <<'CONF'
# 研究室 Overleaf のテンプレート用プロジェクト。
# このファイルはリポジトリの外にあります（public にしても漏れないように）。
#
# OVERLEAF_GIT_BASE
#   Overleaf の git のアドレス。http://git@<ホスト:ポート>/git の形です。
#   学内から直接つなぐなら研究室サーバーのアドレス、
#   学外から SSH トンネル越しに使うなら http://git@localhost:8098/git。
#   プロジェクトを開いて左端の Integrations のアイコンを押すと、
#   clone 用の URL がそのまま出ます。
#
# <名前>_PROJECT_ID
#   Overleaf でプロジェクトを開き、左端の Integrations（統合）のアイコンを
#   押すと出てくる clone 用 URL の、末尾の英数字です。

OVERLEAF_GIT_BASE=

thesis_PROJECT_ID=
exam_PROJECT_ID=
note_PROJECT_ID=
CONF
  echo "設定ファイルの雛形を作りました:"
  echo "  $conf"
  echo "プロジェクト ID を書いてから、もう一度実行してください。"
  exit 1
fi

# shellcheck disable=SC1090
. "$conf"

eval "project_id=\${${name}_PROJECT_ID:-}"
if [ -z "$project_id" ]; then
  echo "$conf に ${name}_PROJECT_ID が書かれていません。" >&2
  exit 1
fi

if [ -z "${OVERLEAF_GIT_BASE:-}" ]; then
  echo "$conf に OVERLEAF_GIT_BASE が書かれていません。" >&2
  exit 1
fi
url="$OVERLEAF_GIT_BASE/$project_id"
work="$cache/$name"

# ---- Overleaf 側を手元に用意する ------------------------------------------
if [ -d "$work/.git" ]; then
  echo "==> Overleaf 側の最新を取得 ($name)"
  if ! git -C "$work" fetch --quiet origin; then
    echo >&2
    echo "Overleaf への接続に失敗しました。" >&2
    echo "  failed to get: -25308 と出ているなら、キーチェーンが読めていません。" >&2
    echo "  Terminal.app から実行するか、~/.netrc に書いてください（冒頭の説明を参照）。" >&2
    exit 1
  fi
  br=$(git -C "$work" rev-parse --abbrev-ref HEAD)
  git -C "$work" reset --hard --quiet "origin/$br"
else
  echo "==> Overleaf のプロジェクトを clone ($name)"
  echo "    $url"
  mkdir -p "$cache"
  rm -rf "$work"
  if ! git clone --quiet "$url" "$work"; then
    echo >&2
    echo "clone に失敗しました。Overleaf の Git トークンが要ります。" >&2
    echo "  1. Overleaf 右上 -> Account Settings で Git 認証トークンを発行する" >&2
    echo "     （表示は一度きりです。その場で控えてください）" >&2
    echo "  2. もう一度この script を実行し、パスワードを聞かれたらトークンを入れる" >&2
    echo "     （ユーザー名は git。macOS なら次からは keychain が覚えます）" >&2
    rm -rf "$work"
    exit 1
  fi
fi

# ---- 送る前の注意 ---------------------------------------------------------
if ! git -C "$root" diff --quiet HEAD -- "$name/"; then
  echo "注意: $name/ にコミットしていない変更があります。" >&2
  echo "      作業ツリーの中身をそのまま送るので、Overleaf 側とこのリポジトリの" >&2
  echo "      履歴がずれます。先にコミットしておくことを勧めます。" >&2
  echo >&2
fi

# ---- git が管理しているファイルだけを写す ---------------------------------
# ビルドの中間ファイルや PDF が混ざらないよう、追跡対象だけを送ります。
echo "==> $name/ の内容を写す"
find "$work" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +

# （ファイル名に改行を含めないこと。この用途では起こりません）
git -C "$root" ls-files "$name/" | while IFS= read -r f; do
  rel=${f#"$name"/}
  mkdir -p "$work/$(dirname "$rel")"
  cp "$root/$f" "$work/$rel"
done

# ---- 差分を見せる ---------------------------------------------------------
cd "$work"
git add -A
if git diff --cached --quiet; then
  echo "==> Overleaf 側は最新です。送るものはありません。"
  exit 0
fi

echo
echo "---- Overleaf 側に反映される変更 ----"
git diff --cached --stat
echo "-------------------------------------"
echo

if [ "$dry" -eq 1 ]; then
  echo "（--dry-run なので、ここで止めます）"
  git reset --hard --quiet
  exit 0
fi

# ---- 送る -----------------------------------------------------------------
sha=$(git -C "$root" rev-parse --short HEAD)
branch=$(git rev-parse --abbrev-ref HEAD)
git commit --quiet -m "latex-template $sha の $name/ を反映"
git push --quiet origin "$branch"

echo "==> 送りました（latex-template ${sha}）"
echo
echo "テンプレートに反映するには、Overleaf 側でもう一手あります。"
echo "  1. Overleaf でこのプロジェクトを開く"
echo "  2. 一度コンパイルする（成功していないと次のメニューが押せません）"
echo "  3. Menu -> Publish as a Template で公開し直す（更新もこの項目）"
echo
echo "すでに学生が作ったプロジェクトには反映されません（それでよいはずです）。"
