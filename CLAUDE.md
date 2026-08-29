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
* 堀田自身の講義資料がすでに `ltjarticle` +
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

### guide.tex は本文に入れない（2026-08-29）

当初は `main.tex` から `\input{guide}` して、書き終わったら外す運用にしていたが、
本人の判断で外した。手引きは `guide-only.tex` から独立した PDF にして渡す。
学生が消し忘れて提出する事故もなくなる。

### note/ は「まとまった技術ノート」用（2026-08-29 全面書き直し）

初稿は日次の研究ノート（定理環境・付箋箱・TODO マーカー）を想定していたが、
**日常のノートは `~/Repository/notes`（Obsidian vault）でやっている**とのことで、
狙いが違った。ここで作りたいのは次のような、まとまった解説文書。

* `~/Repository/sht_py/README/README.tex` … 球面調和関数展開の説明
* `class/2022/宇宙物理学A/mhd/mhd.tex` … 磁気流体力学の講義ノート

どちらも `ltjarticle` + `\maketitle` + `\tableofcontents` + `\section` の連なりで、
`align` の数式と図が主役。**定理環境も tcolorbox も使っていない**ので全部外した。
本人が実際に書いているものに合わせること。

### guide.tex は堀田本人の指導方針・文体で書いてある（2026-08-29 改稿）

初稿は話題の区切りを奥村版のファイル名から借りていたうえ、文体も禁止事項の
列挙になっていて嫌味っぽかったため、本人の指示で二度書き直した。

**推測で指導方針を書き足さないこと。** 本人が書いた文章（発表の心得、
AI との付き合い方、研究グループ加入にあたって）を一次資料として、
そこに書いてあることだけを使う。

文体は **です・ます調で学生に語りかける形**。次の 3 つを外さないこと。
初稿はこれを全部落としたために嫌味な文章になった。

* 自分を下げる（「私も毎回大変です」「私も学生の頃はよく直されました」）
* 共感してから言う（「気持ちはよく分かります」「正直つらいと思います」）
* 楽しさに戻る（最後は必ず前向きに閉じる）

禁止形（「〜してはいけません」）より依頼形（「〜しないでください」）を選ぶ。
相手を疑う書き方（「隠さないでください」）や、こちらの都合を持ち出す書き方
（「私の時間を使わせないでください」）は書かない。

本人が挙げた「毎年同じことを言っている」指摘：

1. イントロダクションは最後に書く。全ての結果が揃ってから、それに対応させて書く
2. 結論はイントロダクションに対応させる
3. 自分が苦労したところではなく、結論につながる論理に重要なことを論理的に並べる
4. 図は論文に貼り付けて印刷し、それでも軸の文字が読めるように調整する
   （Hotta et al. 2022 を参考にさせる）。カラーバーは必ずつける。
   キャプションが長いのは好きではない

章立ては「序論・手法（モデルの説明）・結果・議論・結論」で固定。
数値シミュレーションがほとんどのため。

添削は研究室の Overleaf 内で完結し、学生にはラベル（`review-hotta` の形）を
付けてもらう。日常の添削で latexdiff は使わない。
**この運用の正本は別に配っている「研究室 Overleaf 利用案内」なので、
guide.tex にも README にも詳細を複製しない**（二重管理は腐る）。

### GitHub Actions で 4 つの PDF を作る（2026-08-29 追加）

当初は入れない判断だったが、本人の希望で追加した。
`.github/workflows/build.yml` が `sync-common.sh --check` →
`texlive/texlive:latest` の Docker で 4 つの PDF をビルド → artifact、をやる。

* ランナーに apt で TeX Live を入れるのではなく `docker run` にしているのは、
  `actions/checkout` をホスト側の git で確実に動かすため
  （`container:` にすると texlive イメージに git がある保証がない）。
* `paths` フィルタを付けてあるので、README だけ直したときは走らない。
* できた PDF は **GitHub Pages** に置く（`site/` を組み立てて
  `upload-pages-artifact` → `deploy-pages`）。artifact は URL が実行ごとに変わり、
  ログインが要り、90 日で消えるので、学生に渡すリンクには使えない。
  **Settings -> Pages の Source を「GitHub Actions」にする設定が一度だけ要る。**
  private のあいだは公開されない。
  `thesis/main.tex` の冒頭が手引きの URL を指しているので、
  Pages を止めるならそこも直すこと。
* private repo でも無料枠 2000 分/月に対して 1 回 5 分程度なので問題にならない。

**手引きだけの PDF (`guide-only.pdf`)**：`guide-only.tex` は `main.tex` とは別の、
ふつうの独立した文書。設定だけを同じ `preamble.tex` から読む。
配って読ませるものなので `oneside`（白紙ページが入らない）。

> 当初は `\def\GuideOnly{}` してから `\input{main}` し、`main.tex` 側で
> `\ifdefined\GuideOnly` で分岐させていたが、「わかりにくい」と却下された。
> `preamble.tex` を切り出したことで分岐なしで書けるようになった。

### 学生が触るファイルを絞る（2026-08-29）

「学生が触るファイルは一つだけ」にしたいという要望で、`main.tex` を
`\usepackage{thesiscover}` の位置で二つに割った。

* `main.tex` … 表紙に載る情報、概要、章の並び。**書き換えるのはここ**
* `preamble.tex` … `\documentclass` 以外のパッケージと設定。触らない

**`\documentclass` だけは `main.tex` に残してある。** Overleaf は
`\documentclass` を探して Main document の候補を出すので、`main.tex` から
消すと `preamble.tex` のほうが主文書と判定されかねない。
片面印刷への切り替え行でもあるので、1 行だけ残すのが安全。

`guide.tex` / `preamble.tex` の先頭には、単体で `latexmk` に
渡されたときに一度だけメッセージを出して止まるガードを入れてある
（`\ifdefined\chapter\else ... \stop \fi`）。
これがないと `nullfont` の Missing character が数千行出たあとに落ちる。

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
  `guide.tex` 単体でエラーになるので `latexmkrc` に
  `@default_files = ('main.tex');` を書いてある。
* **BibTeX は `%` 始まりの行をコメントとして飛ばさない。** `.bib` のコメントに
  アットマークを含む文字列を書くと、そこから新しい項目が始まったと誤解される。
* `Package caption Warning: Unknown document class` は `caption` が `ltjsbook` を
  知らないだけ。実害なし。`main.tex` にその旨を書いてある。

## Overleaf との連携（2026-08-29）

学生は研究室 Overleaf の **New Project → Templates** から始める。
LuaLaTeX の compiler 設定はテンプレートから引き継がれることを実機で確認済み。

`tools/push-to-overleaf.sh <名前>` が、git-bridge 経由で
このリポジトリ → Overleaf のテンプレート用プロジェクトの一方向同期をする。

* **正本はこのリポジトリ。** Overleaf 側は写しで、画面で直接編集しても次回上書きされる。
* 送るのは `git ls-files` に出るものだけ。PDF や中間ファイルは混ざらない。
* サブディレクトリ（`thesis/`）→ Overleaf プロジェクトのルート、という写し替えがあるので
  `git push` では済まない。`git subtree push` も考えたが、Overleaf 画面での編集が
  1 回でも入ると失敗して分かりにくいので、毎回まるごと上書きする形にした。
* 接続先は **repo の外**（`~/.config/latex-template/overleaf.conf`）。
  public にしたときに学内アドレスとプロジェクト ID を出さないため。
* 送ったあと、テンプレートへの反映は手動（Overleaf で一度コンパイル →
  Menu → **Publish as a Template**）。**コンパイル済みでないとメニューが押せない。**
  更新も同じ項目。`version` が上がり、中身が焼き直される。
  ソースの `manage-template-modal` という名前に引きずられて「Manage template」と
  書いていたが、UI にその文字列は出ない（メニューもモーダルの題も
  `t('publish_as_template')`）。
* **メタデータの Edit（テンプレートのページから）と、中身の焼き直しは別物。**
  Edit は名前・ライセンス・説明を書き換えるだけで `version` は上がらず、
  プロジェクト側の変更は反映されない。

### CE+ のテンプレートギャラリーは既定で無効

`template-gallery` モジュールはイメージに入っているが、
`OVERLEAF_TEMPLATE_GALLERY=true` を立てないと `Settings.templates` が作られず、
`Features.hasFeature('templates-server-pro')` が false になって
**管理者でもメニューに出ない**。2026-08-29 に研究室サーバーで有効化済み。

## ビルドが不可解に失敗するとき

`TEXINPUTS` や `BIBINPUTS` に個人用のスタイルファイル置き場を通していると、
TeX Live のパッケージがそちらで上書きされることがある。
古い `natbib.sty` が読まれて `\setcitestyle` が
「Undefined control sequence」になる、といった形で出る。

```sh
kpsewhich -all natbib.sty      # 複数出たら疑う
env -u TEXINPUTS -u BIBINPUTS latexmk   # 切り分け
```

CI は素の TeX Live で動くので、手元だけで起きる問題はここで切り分けられる。

## 未確定・TODO

* **表紙の所属の正式名称が未確認。** 現在は暫定で
  `名古屋大学大学院 / 理学研究科 / 理学専攻 物理科学領域` を既定にしてある。
  研究科・専攻・領域・研究室名を、学務に出す書類の表記に合わせて確定させること。
  変数化してあるので `thesis/main.tex` の 1 か所を直せばよい。
* `thesis/fig/sample.pdf` は pgfplots で作った仮の図。差し替えてよい。
* 学生に配るときの運用（このリポジトリを fork させるか、zip を渡すか）は未決。
