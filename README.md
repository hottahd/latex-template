# latex-template

堀田グループの LaTeX テンプレート集です。修士論文・卒業論文、講義の試験、
研究ノートの 3 つを同じ書き方・同じコマンドで作れるようにしてあります。

| ディレクトリ | 用途 | クラス |
|---|---|---|
| `thesis/` | 修士論文・卒業論文 | `ltjsbook` |
| `exam/`   | 試験・小テスト（問題用と解答例つきを切り替え） | `ltjarticle` |
| `note/`   | 研究ノート・講義ノート | `ltjsarticle` |

**エンジンは LuaLaTeX です。`platex` や `uplatex` では動きません。**
TeX Live（MacTeX）さえ入れれば Mac / Windows / Linux のどれでも同じ PDF が出ます。
和文フォントは TeX Live に同梱の原ノ味フォントを使うので、フォントの設定は要りません。

---

## 使い方

使いたいディレクトリに入って `latexmk` と打つだけです。

```sh
cd thesis
latexmk          # main.pdf ができる
latexmk -pvc     # 保存するたびに自動で作り直す（書きながら使うならこれ）
latexmk -c       # 中間ファイルを消す（PDF は残る）
latexmk -C       # 中間ファイルと PDF を消す
```

`latexmk` にファイル名を渡すときは、`\documentclass` を持っているファイルを
指定してください。`thesis/` では `main.tex` と `guide-only.tex` の 2 つだけです。
`guide.tex` と `preamble.tex` は断片なので単体では組めません
（間違えて叩いても、その旨のメッセージを出して止まるようにしてあります）。

`thesis/` `exam/` `note/` はそれぞれ独立していて、他のディレクトリに依存しません。
必要なものだけをコピーして持っていけます。

---

## 環境の用意

### macOS

```sh
brew install --cask mactex-no-gui     # Homebrew を使う場合
```

または [MacTeX](https://tug.org/mactex/) の `.pkg` をダウンロードして入れます。
インストール後、ターミナルを開き直してから

```sh
lualatex --version
```

でバージョンが出れば成功です。

### Windows

1. [TeX Live のインストーラ](https://www.tug.org/texlive/acquire-netinstall.html)
   （`install-tl-windows.exe`）をダウンロードして実行する。
2. インストールの種類は **full**（既定）を選ぶ。数時間かかることがあります。
3. インストール後、PowerShell を開き直して `lualatex --version` を確認する。

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

```sh
cd note
latexmk
```

`main.pdf` ができれば環境は整っています。

---

## VS Code で書く

拡張機能 **LaTeX Workshop**（James Yu）を入れて、このリポジトリを開いてください。
`.vscode/settings.json` に設定を入れてあるので、それ以上の設定は要りません。

* `.tex` を保存すると自動でコンパイルされます
* `Ctrl`/`Cmd` + `Alt` + `J` で PDF の該当箇所へ飛べます
* PDF を `Ctrl`/`Cmd` + クリックすると `.tex` の該当行へ戻れます

---

## Overleaf で書く

修士論文は研究室の Overleaf で書き、添削もその中で完結させます。
アクセス方法・アカウント・添削の流れは、別に配ってある
**「研究室 Overleaf 利用案内」**（MS Loop）を見てください。ここでは重複させません。

修士論文は**テンプレートから始められます**。
研究室 Overleaf の **New Project → Templates** に登録してあるので、
そこから作れば LuaLaTeX の設定も付いてきます。ファイルを持ち込む必要はありません。

添削を頼むときは、その版に `review-hotta` のようなラベルを付けて連絡します。
`latexdiff` で差分の PDF を作る必要はありません。

### テンプレートを更新する（堀田用）

このリポジトリが正本で、Overleaf 側は写しです。
リポジトリを直したら、次のコマンドで送ります。

```sh
./tools/push-to-overleaf.sh thesis --dry-run   # 何が変わるか見るだけ
./tools/push-to-overleaf.sh thesis             # 送る
```

git-bridge 経由で、**git が管理しているファイルだけ**を Overleaf 側に上書きします
（PDF や中間ファイルは混ざりません）。送ったあと、テンプレートに反映するには
Overleaf でプロジェクトを開いて**一度コンパイルし**、
**Menu → Publish as a Template** で公開し直します。コンパイルしていないとメニューが押せません。
すでに学生が作ったプロジェクトには反映されません。

接続先（プロジェクト ID と学内アドレス）は、このリポジトリではなく
`~/.config/latex-template/overleaf.conf` に置いています。
初回だけ Overleaf の Git 認証トークンを聞かれます
（Account Settings で発行。表示は一度きり。ユーザー名は `git`）。

---

## 共通プリアンブル `achilles.sty`

フォント、数式、単位、図、色、よく使うマクロは `achilles.sty` にまとめてあります。
3 つのテンプレートすべてで同じものを読んでいます。

**原本は `common/achilles.sty` です。** 各テンプレートにあるのはコピーです。
これは「ディレクトリを 1 つ持っていけばそのまま Overleaf で通る」ようにするためで、
シンボリックリンクにしていないのは Windows と Overleaf の両方でつまずかないためです。

原本を編集したら、配り直してください。

```sh
./tools/sync-common.sh           # common/ の内容を各テンプレートにコピー
./tools/sync-common.sh --check   # ずれていないか検査する
```

`latexmkrc` も同じ仕組みで配っています。

主なマクロ:

| 書き方 | 出るもの |
|---|---|
| `\vect{B}` | 太字斜体のベクトル |
| `\grad` `\divergence` `\curl` `\lap` | ∇ 系の演算子 |
| `\pdif{f}{x}` `\diff{f}{x}` | 偏微分・常微分 |
| `\qty{700}{Mm}` `\unit{\km\per\second}` | 単位つきの数値（siunitx） |
| `\red{...}` `\todo{...}` | 執筆中の目印。提出前に grep して消す |

---

## 修士論文を書く人へ

`thesis/` のファイルはこれだけです。

**書き換えるファイル**

| ファイル | 中身 |
|---|---|
| `main.tex` | 表紙に載る情報、アブストラクト、本文 |
| `thesis.bib` | 引用文献。NASA ADS の BibTeX をそのまま貼る |
| `fig/` | 図 |

**触る必要のないファイル**

| ファイル | 中身 |
|---|---|
| `preamble.tex` | パッケージと設定。余白や文献の形式を変えるときだけ |
| `achilles.sty` | 全テンプレート共通のプリアンブル |
| `thesiscover.sty` | 表紙のレイアウト |
| `guide.tex` | 執筆の手引き（堀田の指導方針）。論文の本文には入らない |
| `guide-only.tex` | 手引きだけを 1 冊の PDF にする。`latexmk guide-only.tex` |

* 表紙の所属は `main.tex` の変数で設定します。`thesiscover.sty` は触りません。
  **正式名称は指導教員に確認し、学務に出す書類と表記を揃えてください。**
* 卒業論文に使うときは `\thesistype{卒業論文}` に変えます。
* 参考文献は `biblatex + biber`（既定）と `natbib + plainnat` を
  `main.tex` の冒頭で切り替えられます。本文の `\citep{}` `\citet{}` は共通なので、
  あとから変えても原稿は書き直さなくて済みます。
* **まず `guide.tex`（PDF では「修士論文を書くにあたって」の章）を読んでください。**
  手引きだけを読みたいときは `latexmk guide-only.tex` で単体の PDF になります。
  GitHub Actions が作ったものを Artifacts から落としても構いません。
  イントロは最後に書くこと、結論をイントロに対応させること、図は印刷して確かめること、
  単位や添字の約束、引用と剽窃、AI との付き合い方、添削の受け方をまとめてあります。

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

`note/main.tex` は 1 ファイルで完結しています。
定義・定理・例・注意の環境と、`\begin{memo}[見出し]` の覚え書き用の箱、
`\yokakunin{...}` の未確認事項マーカーを用意してあります。

---

## GitHub Actions

`main` に push すると、`.github/workflows/build.yml` が

1. `common/` と各テンプレートがずれていないか検査し（`sync-common.sh --check`）
2. TeX Live の Docker イメージで 4 つの PDF を作り
3. Artifacts として残します

作られるのは `thesis/main.pdf`、`thesis/guide-only.pdf`、`exam/main.pdf`、`note/main.pdf` の
4 つです。Actions の実行結果のページの一番下、**Artifacts** から落とせます。

目的は 2 つあります。TeX を入れていない人でも PDF を読めるようにすることと、
**TeX Live が上がったときや誰かがプリアンブルを触ったときに、壊れたことを
push の時点で知る**ことです。手元だけで確認していると、
「学生の環境で通らない」にあとから気づくことになります。

手動で走らせたいときは Actions のページの **Run workflow** から実行できます。

## ライセンス

MIT License（`LICENSE`）。自由に使ってください。改変も再配布も構いません。

研究室 Overleaf のテンプレートでは、ライセンスの選択肢が
Creative Commons CC BY 4.0 / LaTeX Project Public License 1.3c / Other の 3 つしか
ないので、**Other (as stated in the work)** を選んでいます。実際のライセンスは
この `LICENSE` に書いてあるものです。

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
