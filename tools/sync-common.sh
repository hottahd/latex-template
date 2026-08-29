#!/bin/sh
# common/ 以下の共通ファイルを各テンプレートに配る。
#
#   ./tools/sync-common.sh          コピーする
#   ./tools/sync-common.sh --check  ずれがないか検査する（CI や提出前の確認用）
#
# 各テンプレートのディレクトリは「そのまま Overleaf に上げれば通る」状態に
# しておきたいので、共通ファイルはシンボリックリンクではなく実体をコピーする。
# （Windows のシンボリックリンクと Overleaf の両方でつまずかないため）

set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
files="achilles.sty latexmkrc"
targets="thesis exam note"

check=0
[ "${1:-}" = "--check" ] && check=1

status=0
for t in $targets; do
  for f in $files; do
    src="$root/common/$f"
    dst="$root/$t/$f"
    if [ "$check" -eq 1 ]; then
      if ! cmp -s "$src" "$dst"; then
        echo "差分あり: $t/$f (common/$f が原本)"
        status=1
      fi
    else
      cp "$src" "$dst"
      echo "copied: common/$f -> $t/$f"
    fi
  done
done

if [ "$check" -eq 1 ] && [ "$status" -eq 0 ]; then
  echo "すべて common/ と一致しています"
fi
exit $status
