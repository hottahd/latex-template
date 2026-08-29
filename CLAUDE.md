# latex-template — 設計メモ

堀田グループの LaTeX テンプレート集。使い方は `README.md` を見ること。
このファイルは「なぜそうなっているか」を残すためのもの。

## 前提

* 参考にしたのは <https://github.com/akira-okumura/MasterThesisTemplate>。
  ただし移植ではない。構成と「執筆ガイドを同梱する」という考え方を借りて、
  中身は書き直してある（奥村版の文章は使っていない）。
* 学生が Mac / Windows / Linux のどれでも簡単に導入できることを最優先にした。

## 決めたこと

### エンジンは LuaLaTeX に統一

奥村版は uplatex + dvipdfmx + jsbook。これを LuaLaTeX + ltjsbook に置き換えた。

* TeX Live / MacTeX を素で入れれば luatexja と原ノ味フォントが同梱されており、
  OS によらずフォント設定なしで同じ PDF が出る。
  uplatex→dvipdfmx は Windows での和文フォント埋め込みでつまずきやすい。
* 堀田自身の講義資料（`~/Dropbox/Documents/class/*/`）がすでに `ltjarticle` +
  LuaLaTeX なので、講義テスト・ノートと論文でツールチェインが 1 本になる。
* Overleaf も LuaLaTeX を選ぶだけで通る。
* 代償：`pxjahyper`、`otf`、`jecon*.bst` など (u)pLaTeX 前提の資産は使えない。
  しおりの文字化け対策は LuaLaTeX では不要なので実害はない。

### ディレクトリごとに自己完結させている

`common/achilles.sty` と `common/latexmkrc` が原本で、`tools/sync-common.sh` が
`thesis/` `exam/` `note/` に**実体をコピー**する。シンボリックリンクではない。

理由：Overleaf のプロジェクトは 1 文書 = 1 プロジェクトなので、学生は
`thesis/` の中身だけを zip で上げる。`\usepackage{../common/achilles}` や
`TEXINPUTS` を前提にすると、そこで破綻する。Windows のシンボリックリンクも避けたい。

重複は `tools/sync-common.sh --check` で検出する。

### 共通 sty の名前は `achilles`

`hottastyle` のような名乗りは避けたいという本人の希望。TeX Live に同名パッケージなし。

### 参考文献は 2 方式を切り替え

`thesis/main.tex` 冒頭の `\def\BibStyleBiblatex{}` / `\def\BibStyleNatbib{}` で切り替え。
本文の `\citep` `\citet` はどちらでも同じなので、後から変えても原稿はそのまま。

* 既定は `biblatex + biber`（UTF-8 の日本語文献がそのまま通る）。
* natbib 側の `.bst` は `plainnat` にしてある。`aasjournalv7` も TeX Live に
  入っているが、AASTeX 外で使うと本文の引用が「(P. Charbonneau 2020)」と
  イニシャル付きになるので既定から外した。

### ファイルを増やしすぎない

本人の希望で、章ごとの分割はしていない。`thesis/` は
`main.tex` / `body.tex` / `guide.tex` / `thesis.bib` + sty 2 つだけ。
プリアンブルと表紙情報も `main.tex` に入れてある。

## 実装上のはまりどころ（再発防止）

* **`newtxmath` と `amssymb` は併用できない。** `\Bbbk` が二重定義になって止まる。
  `achilles.sty` では `amssymb` を読まない。読み込み順は
  `amsmath` → `mathtools` → `fontenc` → `newtxtext` → `newtxmath` → `bm`。
* **`\mathscr` は `newtxmath` が持っている。** `mathrsfs.sty` は 5/7/10pt しか
  なく、和文クラスの 10.5pt でサイズ置換の警告を出し続けるので読まない。
  なお `newtxmath` に `scr=` というオプションは**ない**（指定するとエラー）。
* **`newtxmath` は `\openbox` を定義する。** `amsthm` と衝突するので、
  `note/main.tex` では `\let\openbox\relax` してから `amsthm` を読む。
* **`tabular` の中で `\ifx ... \\ ... \fi` と書くと壊れる。** 桁分けの走査と
  条件分岐が噛み合わない。`thesiscover.sty` では条件分岐を表の外で完結させ、
  空欄の判定は `\thc@line` で `\par` 区切りにしている。
* **`latexmk` は引数なしだとディレクトリ内の全 `.tex` を組もうとする。**
  `body.tex` 単体でエラーになるので `latexmkrc` に
  `@default_files = ('main.tex');` を書いてある。
* **BibTeX は `%` 始まりの行をコメントとして飛ばさない。** `.bib` のコメントに
  アットマークを含む文字列を書くと、そこから新しい項目が始まったと誤解される。
* `Package caption Warning: Unknown document class` は `caption` が `ltjsbook` を
  知らないだけ。実害なし。`main.tex` にその旨を書いてある。

## 環境について（堀田のマシン固有）

シェルが以下を設定しているため、TeX Live のパッケージが個人用のもので
上書きされることがある。

```
TEXINPUTS=:/Users/hotta/Dropbox/tex/sty:
BIBINPUTS=:/Users/hotta/Dropbox/tex/bib:
```

実際 `/Users/hotta/Dropbox/tex/sty/natbib.sty` は **1998 年版 (6.8c)** で、
TeX Live 2026 の natbib (8.31b) を隠してしまう。`\setcitestyle` が
「Undefined control sequence」になるのはこれが原因。学生の環境では起きない。
確認は `kpsewhich -all natbib.sty`。整理するか、このリポジトリを触るときだけ
`env -u TEXINPUTS -u BIBINPUTS latexmk` で回避する。

## 未確定・TODO

* **表紙の所属の正式名称が未確認。** 現在は暫定で
  `名古屋大学大学院 / 理学研究科 / 理学専攻 物理科学領域` を既定にしてある。
  研究科・専攻・領域・研究室名を、学務に出す書類の表記に合わせて確定させること。
  変数化してあるので `thesis/main.tex` の 1 か所を直せばよい。
* `thesis/fig/sample.pdf` は pgfplots で作った仮の図。差し替えてよい。
* 学生に配るときの運用（このリポジトリを fork させるか、zip を渡すか）は未決。
