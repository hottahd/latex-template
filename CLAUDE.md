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

### guide.tex は堀田本人の指導方針・文体で書いてある（2026-08-29 改稿）

初稿は話題の区切りを奥村版のファイル名から借りていたため、本人の指示で全面的に
書き直した。**推測で書き足さないこと。** 元にした資料は次の 3 つ。

* 発表の心得（文体の見本。です・ます調、学生への語りかけ、具体例が長い、
  自称は「私」と「堀田」）
  <https://sites.google.com/site/hideyukihotta/home/note/student_1>
* 学生の研究における AI との付き合い方
  <https://hotta.notion.site/AI-3a604f9ef588804f92dceed12fcb99b7>
* 堀田研究グループ加入にあたって（指導哲学）
  Notion ページ `c902d3e9-d4d2-4c25-bbf5-4b617d8db94d`
* 添削の運用 → `~/Repository/overleaf-guide/guide.md`（正本は MS Loop）

Notion ページは公開 URL を WebFetch しても本文が取れない（SPA）。
`~/Repository/notes/meta/notion.py --page <ハイフン付き ID>` で
Notion デスクトップアプリのローカル DB から読める。

本人が挙げた「毎年同じことを言っている」指摘：

1. イントロダクションは最後に書く。全ての結果が揃ってから、それに対応させて書く
2. 結論はイントロダクションに対応させる
3. 自分が苦労したところではなく、結論につながる論理に重要なことを論理的に並べる
4. 図は論文に貼り付けて印刷し、それでも軸の文字が読めるように調整する
   （Hotta et al. 2022 を参考にさせる）。カラーバーは必ずつける。
   キャプションが長いのは好きではない

章立ては「序論・手法（モデルの説明）・結果・議論・結論」で固定。
数値シミュレーションがほとんどのため。

添削は研究室 Overleaf 内で完結。ラベル `review-hotta` を付けて連絡させる。
日常の添削で latexdiff は使わない。コメント・提案を学生に承認・却下させない。
**この運用の正本は MS Loop の「研究室 Overleaf 利用案内」なので、
guide.tex にも README にも詳細を複製しない**（二重管理は腐る）。

### ファイルを増やしすぎない

本人の希望で、章ごとの分割はしていない。`thesis/` は
`main.tex` / `body.tex` / `guide.tex` / `thesis.bib` + sty 2 つだけ。
プリアンブルと表紙情報も `main.tex` に入れてある。

### GitHub Actions で 4 つの PDF を作る（2026-08-29 追加）

当初は入れない判断だったが、本人の希望で追加した。
`.github/workflows/build.yml` が `sync-common.sh --check` →
`texlive/texlive:latest` の Docker で 4 つの PDF をビルド → artifact、をやる。

* ランナーに apt で TeX Live を入れるのではなく `docker run` にしているのは、
  `actions/checkout` をホスト側の git で確実に動かすため
  （`container:` にすると texlive イメージに git がある保証がない）。
* `paths` フィルタを付けてあるので、README だけ直したときは走らない。
* private repo でも無料枠 2000 分/月に対して 1 回 5 分程度なので問題にならない。

**手引きだけの PDF (`guide-only.pdf`) の作り方**：`guide.tex` は `\chapter` なので
単体ではコンパイルできない。プリアンブルを複製したくないので、
`thesis/guide-only.tex` は `\def\GuideOnly{}` してから `\input{main}` するだけの
3 行のファイルにしてある。`main.tex` 側は `\ifdefined\GuideOnly` で
表紙・概要・本文・付録・謝辞を飛ばし、簡単な扉と目次と `\input{guide}` だけを出す。
引用文献はどちらの経路でも出す（guide の中で引用しているため）。
`\documentclass` の前に `\def` を置くのは合法。

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
