# latex-template

堀田グループ（名古屋大学 ISEE）の LaTeX テンプレート集です。
修士論文・卒業論文、講義の試験、まとまったノートの 3 つを、
同じ書き方・同じコマンドで作れるようにしてあります。

| ディレクトリ | 用途 | クラス |
|---|---|---|
| `thesis/` | 修士論文・卒業論文 | `ltjsbook` |
| `exam/`   | 試験・小テスト（問題用と解答例つきを切り替え） | `ltjarticle` |
| `note/`   | 講義ノート・手法の解説など、まとまった文書 | `ltjarticle` |

**エンジンは LuaLaTeX です。`platex` や `uplatex` では動きません。**
和文フォントは TeX Live に同梱の原ノ味フォントを使うので、
Mac / Windows / Linux のどれでも、フォントの設定なしに同じ PDF が出ます。

`thesis/` `exam/` `note/` はそれぞれ独立していて、他のディレクトリに依存しません。
必要なものだけをコピーして持っていけます。

---

## 修士論文・卒業論文を書く人へ

### まず手引きを読んでください

<https://hottahd.github.io/latex-template/guide-only.pdf>

イントロダクションは最後に書くこと、結論をイントロに対応させること、
図は印刷して確かめること、単位や添字の約束、引用と剽窃、AI との付き合い方、
添削の受け方をまとめてあります。書き始める前に一度目を通してください。

論文の本文には入らないので、消し忘れて提出してしまう心配は要りません。
手元で作りたいときは `thesis/` で `latexmk guide-only.tex` です。

### 始め方

研究室の Overleaf の **New Project → Templates → 修士論文** から作ってください。
LuaLaTeX の設定も付いてくるので、ファイルを持ち込む必要はありません。

Overleaf のアクセス方法・アカウント・添削の流れは、別に配ってある
**「研究室 Overleaf 利用案内」**（MS Loop）を見てください。ここでは重複させません。

添削を頼むときは、その版に `review-hotta` のようなラベルを付けて連絡します。
`latexdiff` で差分の PDF を作る必要はありません。

### 書き換えるファイル

| ファイル | 中身 |
|---|---|
| `main.tex` | 表紙に載る情報、アブストラクト、本文 |
| `thesis.bib` | 引用文献。NASA ADS の BibTeX をそのまま貼る |
| `fig/` | 図 |

### 触る必要のないファイル

| ファイル | 中身 |
|---|---|
| `preamble.tex` | パッケージと設定。余白や文献の形式を変えるときだけ |
| `achilles.sty` | 全テンプレート共通のプリアンブル |
| `thesiscover.sty` | 表紙のレイアウト |
| `guide.tex` | 執筆の手引きの中身 |
| `guide-only.tex` | 手引きだけを 1 冊の PDF にする |

### 覚えておくこと

* 表紙の所属は `main.tex` の変数で設定します。`thesiscover.sty` は触りません。
  **正式名称は指導教員に確認し、学務に出す書類と表記を揃えてください。**
* **卒業論文にも同じテンプレートを使えます。** `\thesistype{卒業論文}` に変えるだけです。
* 参考文献は `biblatex + biber`（既定）と `natbib + plainnat` を
  `preamble.tex` の冒頭で切り替えられます。本文の `\citep{}` `\citet{}` は共通なので、
  あとから変えても原稿は書き直さなくて済みます。
* **数式の記法には独自のコマンドを用意していません。**
  `\nabla\cdot` や `\frac{\partial f}{\partial x}` はそのまま書いてください。
  ここだけで通じる書き方を覚えても、他所で論文を書くときに使えないためです。
  ベクトルは `bm` パッケージの `\bm{B}` を使います。

---

## 試験を作る人へ

`exam/main.tex` の冒頭にある 1 行で、問題用と解答例つきを切り替えます。

```latex
\showanswerfalse   % 問題用（解答は出力されない。氏名欄と注意書きがつく）
%\showanswertrue   % 解答例つき（表題に「解答例」がつく）
```

解答は `\begin{kaitou} ... \end{kaitou}` で囲みます。
`\end{kaitou}` は独立した行に書いてください（`comment` パッケージの制約です）。
問題用のときだけ答案の余白を空けたい場合は `\ansspace{4cm}` を使います。
配点は `\section{太陽の自転\haiten{20}}` のように見出しの中に書きます。

問題文が 1 つしかないので、問題用と解答例で中身が食い違うことがありません。

```sh
latexmk && mv main.pdf 期末テスト_問題.pdf
# \showanswertrue に変えてから
latexmk && mv main.pdf 期末テスト_解答例.pdf
```

---

## ノートを書く人へ

講義ノートや手法の解説のように、**一つの話題をまとまった形で書き切る文書**のための
テンプレートです。日々の研究ノートではありません。

`note/main.tex` は 1 ファイルで完結しています。`\maketitle` → `\tableofcontents` →
`\section` の連なりで、数式・図・表の書き方の実例だけを置いてあります。
節が増えたら `\input{advection}` のように分けられます。

---

## 手元で書く

Overleaf を使わない場合、あるいは試験やノートを作る場合は、手元に TeX Live が要ります。

### macOS

```sh
brew install --cask mactex-no-gui     # Homebrew を使う場合
```

または [MacTeX](https://tug.org/mactex/) の `.pkg` をダウンロードして入れます。
`mactex-no-gui` は GUI のツール類が付かないだけで、中身は同じです。

### Windows

1. [TeX Live のインストーラ](https://www.tug.org/texlive/acquire-netinstall.html)
   （`install-tl-windows.exe`）をダウンロードして実行する。
2. インストールの種類は **full**（既定）を選ぶ。数時間かかることがあります。
3. インストール後、PowerShell を開き直す。

### Linux

ディストリビューションのパッケージ（`texlive-full`）でも入りますが、
版が古いことがあります。最新の TeX Live を使うほうが確実です。

```sh
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unzipped.tar.gz
tar xzf install-tl-unzipped.tar.gz
cd install-tl-*/
sudo ./install-tl        # scheme-full を選ぶ
```

### 動作確認

ターミナルを開き直してから、

```sh
cd note
latexmk
```

`main.pdf` ができれば環境は整っています。

### latexmk の使い方

```sh
latexmk          # main.pdf ができる
latexmk -pvc     # 保存するたびに自動で作り直す（書きながら使うならこれ）
latexmk -c       # 中間ファイルを消す（PDF は残る）
latexmk -C       # 中間ファイルと PDF を消す
```

`latexmk` にファイル名を渡すときは、`\documentclass` を持っているファイルを
指定してください。`thesis/` では `main.tex` と `guide-only.tex` の 2 つだけです。
`guide.tex` と `preamble.tex` は断片なので単体では組めません
（間違えて叩いても、その旨のメッセージを出して止まるようにしてあります）。

### VS Code

拡張機能 **LaTeX Workshop**（James Yu）を入れて、このリポジトリを開いてください。
`.vscode/settings.json` に設定を入れてあるので、それ以上の設定は要りません。

* `.tex` を保存すると自動でコンパイルされます
* `Ctrl`/`Cmd` + `Alt` + `J` で PDF の該当箇所へ飛べます
* PDF を `Ctrl`/`Cmd` + クリックすると `.tex` の該当行へ戻れます

---

## 困ったとき

* **エラーが出たら `main.log` を上から読む。** 後ろのエラーは前のエラーの
  巻き添えであることが多いので、最初の `.tex:行番号:` を探します。
* **中間ファイルがおかしい**（番号が `??` のまま、文献が出ない）ときは
  `latexmk -C` で全部消してからやり直します。
* **`platex` で組もうとしていないか。** このテンプレートは LuaLaTeX 専用です。
* **`TEXINPUTS` に古い `.sty` を置いていないか。**
  個人用のスタイルファイル置き場が TeX Live より優先されると、
  20 年前の `natbib.sty` などが読まれて謎のエラーになります。
  `kpsewhich -all natbib.sty` で、どれが使われているか確認できます。
* `Package caption Warning: Unknown document class` は `caption` が
  `ltjsbook` を知らないだけで、実害はありません。無視してください。

---

# テンプレートを保守する人へ

ここから下は、テンプレートそのものを直す人向けです。
論文やノートを書くだけなら読む必要はありません。

## 共通プリアンブル `achilles.sty`

フォント、数式、図、単位、執筆中の目印は `achilles.sty` にまとめてあります。
3 つのテンプレートすべてで同じものを読んでいます。

**原本は `common/achilles.sty` です。** 各テンプレートにあるのはコピーです。
これは「ディレクトリを 1 つ持っていけばそのまま Overleaf で通る」ようにするためで、
シンボリックリンクにしていないのは Windows と Overleaf の両方でつまずかないためです。

原本を編集したら、配り直してください。

```sh
./tools/sync-common.sh           # common/ の内容を各テンプレートにコピー
./tools/sync-common.sh --check   # ずれていないか検査する
```

`latexmkrc` も同じ仕組みで配っています。CI でも `--check` を走らせているので、
配り忘れたまま push すると気づけます。

用意してあるコマンドは、執筆中の目印と siunitx の単位だけです。

| 書き方 | 出るもの |
|---|---|
| `\red{...}` `\blue{...}` | 色をつける |
| `\todo{...}` | 赤い `[TODO: ...]`。提出前に grep して消す |
| `\qty{700}{Mm}` `\unit{\km\per\second}` | 単位つきの数値（siunitx） |
| `\Msun` `\Rsun` `\Lsun` `\erg` `\gauss` | siunitx にない単位を足したもの |

## テンプレートを Overleaf に送る

このリポジトリが正本で、Overleaf 側は写しです。
Overleaf の画面で直接編集しても、次に送ったときに上書きされます。

```sh
./tools/push-to-overleaf.sh thesis --dry-run   # 何が変わるか見るだけ
./tools/push-to-overleaf.sh thesis             # 送る
```

git-bridge 経由で、**git が管理しているファイルだけ**を Overleaf 側に上書きします
（PDF や中間ファイルは混ざりません）。

送ったあと、**テンプレートへの反映には Overleaf 側でもう一手あります。**
プロジェクトを開いて**一度コンパイルし**、**Menu → Publish as a Template**
で公開し直してください。コンパイルしていないとメニューが押せません。
更新も同じ項目からで、`version` が上がって中身が焼き直されます。
すでに学生が作ったプロジェクトには反映されません。

> テンプレートのページからの **Edit** は、名前・ライセンス・説明を書き換えるだけです。
> `version` は上がらず、プロジェクト側の変更は反映されません。

接続先（プロジェクト ID と学内アドレス）は、このリポジトリではなく
`~/.config/latex-template/overleaf.conf` に置いています。

認証は Overleaf の Git トークンです（Account Settings で発行。表示は一度きり）。
macOS のキーチェーンは GUI のセッション以外から読めず、
エディタや自動化ツールの中のシェルから走らせると `failed to get: -25308` になります。
`~/.netrc` に書いておくと、どこからでも通ります。

```sh
printf 'machine <Overleaf のホスト>\n  login git\n  password <トークン>\n' >> ~/.netrc
chmod 600 ~/.netrc
```

## GitHub Actions

`main` に push すると、`.github/workflows/build.yml` が

1. `common/` と各テンプレートがずれていないか検査し（`sync-common.sh --check`）
2. TeX Live の Docker イメージで 4 つの PDF を作り
3. GitHub Pages に置きます

狙いは 2 つあります。**TeX を入れていない人に PDF を URL で渡せること**と、
**TeX Live が上がったときや誰かがプリアンブルを触ったときに、
壊れたことを push の時点で知ること**です。
手元だけで確認していると、「学生の環境で通らない」にあとから気づくことになります。

できた PDF はここにあります。

* <https://hottahd.github.io/latex-template/>
* 執筆の手引き … <https://hottahd.github.io/latex-template/guide-only.pdf>

Actions の実行結果のページの **Artifacts** からも落とせます
（Pull Request のときはこちらだけ）。
手動で走らせたいときは Actions のページの **Run workflow** から実行できます。

> Pages は Settings → Pages の Source を「GitHub Actions」にして有効にしてあります。
> 作り直すときは、この設定とリポジトリが public であることの両方が要ります。

## ライセンス

MIT License（`LICENSE`）。自由に使ってください。改変も再配布も構いません。

研究室 Overleaf のテンプレートでは、ライセンスの選択肢が
Creative Commons CC BY 4.0 / LaTeX Project Public License 1.3c / Other の 3 つしか
ないので、**Other (as stated in the work)** を選んでいます。実際のライセンスは
この `LICENSE` に書いてあるものです。
