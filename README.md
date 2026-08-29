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

テンプレートを Overleaf に持っていく手順は次のとおりです。

1. 使いたいディレクトリ（例：`thesis/`）の**中身**を zip にまとめる。
   リポジトリ全体ではなく、そのディレクトリの中身だけにすること。
2. **New Project → Upload Project** から zip を上げる。
3. **Menu → Settings → Compiler** を **LuaLaTeX** に変える。ここが一番忘れやすい。
4. **Main document** が `main.tex` になっていることを確認する。

添削を頼むときは、その版に `review-hotta` のようなラベルを付けて連絡します。
`latexdiff` で差分の PDF を作る必要はありません。

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

| ファイル | 中身 |
|---|---|
| `main.tex` | 設定、表紙に載る情報、概要、章の並び。**書き換えるのは主にここ** |
| `body.tex` | 本文（序論〜結論） |
| `guide.tex` | 執筆の手引き（堀田の指導方針）。書き終わったら `main.tex` の `\input{guide}` を外す |
| `thesis.bib` | 引用文献。NASA ADS の BibTeX をそのまま貼る |
| `achilles.sty` | 共通プリアンブル |
| `thesiscover.sty` | 表紙のレイアウト。通常は触らない |
| `fig/` | 図 |

* 表紙の所属は `main.tex` の変数で設定します。`thesiscover.sty` は触りません。
  **正式名称は指導教員に確認し、学務に出す書類と表記を揃えてください。**
* 卒業論文に使うときは `\thesistype{卒業論文}` に変えます。
* 参考文献は `biblatex + biber`（既定）と `natbib + plainnat` を
  `main.tex` の冒頭で切り替えられます。本文の `\citep{}` `\citet{}` は共通なので、
  あとから変えても原稿は書き直さなくて済みます。
* **まず `guide.tex`（PDF では「修士論文を書くにあたって」の章）を読んでください。**
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
