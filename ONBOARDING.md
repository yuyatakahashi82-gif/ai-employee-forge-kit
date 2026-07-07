# ONBOARDING（はじめての方へ）

## これは何か
この kit は、AI社員（あなた専属で動き続けるAIパートナー）を自分の Mac にゼロから構築するための「設計図＋実行スクリプト」一式です。
実際に構築するには、shell（ターミナルのコマンド）を実行できる「実行エージェント」（Claude Code や Codex など）が必要です。**このドキュメントは、その実行エージェントをまだ持っていない方のための、導入から構築開始までの前段ガイドです。**
すでに Claude Code や Codex を使い慣れている方は、このファイルは読み飛ばして [README.md](./README.md) のクイックスタートから始めてください。

## Step 0: 始める前のチェックリスト

| 項目 | 何のためか | 確認方法 |
|---|---|---|
| macOS（Apple Silicon） | 構築スクリプトの動作前提 | アップルメニュー→「この Mac について」でチップが Apple M1/M2/M3/M4 系であることを確認 |
| Xcode CLT | 各種コマンドラインツールの実行に必要 | ターミナルで `xcode-select --install` を実行。未導入ならインストールダイアログが出るので「インストール」を押す（所要5〜15分） |
| ChatGPT Plus 契約 | AI社員の「脳」にあたる部分の認証に使う（ログインで動くため API 課金は発生しない） | 普段お使いのアカウントで https://chatgpt.com にログインできればOK |
| Discord アカウント＋自分のサーバー | AI社員（bot）を常駐させる場所 | 自分専用の Discord サーバーを1つ用意しておく（無料で作成可） |

## Step 1: 実行エージェントを導入する
Claude Code か Codex CLI、どちらか片方だけで構いません。両方入れる必要はありません。

### Claude Code を使う場合
- すでに Node.js を使ったことがある方: ターミナルで `npm install -g @anthropic-ai/claude-code` を実行
- Node.js が何かよくわからない・入っていない方: https://claude.com/claude-code を開き、案内に沿ってインストーラーを実行してください

### Codex CLI を使う場合
- https://github.com/openai/codex の README にある公式インストール手順に沿って導入してください

## Step 2: kit を渡して自走させる
1. このリポジトリのページ上部にある緑色の「Code」ボタンから URL をコピーし、ターミナルで以下を順に実行します。

   ```
   git clone <このリポジトリのURL>
   cd ai-employee-forge-kit
   cp forge.vars.example forge.vars
   ```

2. Step 1 で導入した実行エージェント（Claude Code や Codex）を、このフォルダの中で起動し、次のように話しかけてください。

   > SKILL.md を読んで、forge.vars の記入を私と対話で埋めてから構築を進めて

   `forge.vars` は事前に自分で全項目を埋めておく必要はありません。実行エージェントが1問ずつ質問してくるので、対話しながら埋めていく設計になっています。

## forge.vars の難所だけ先回り解説
対話で埋まっていきますが、次の3項目だけ意味を先に知っておくと迷いません。

| 変数名 | 何のためか | どう書くか |
|---|---|---|
| `BUILDER_FORBIDDEN_PATTERNS` | 構築の最後に「構築を手伝った人の痕跡が残っていないか」を検査するための検索ワードリスト | 自分だけで構築するなら、自分自身の名前は入れなくてよい |
| `BRAIN_PROVIDER=openai-codex` | AI社員の「脳」に何を使うか | ChatGPT（Codex）を使う設定。変更不要、そのままでOK |
| Discord 関連の項目 | bot をどう作るか・誰に見せるか | bot 作成の具体的な手順は、構築を進める中で実行エージェントが対話形式で案内してくれる |

## 詰まったら
- まず `DRYRUN=1` を付けて素振りする（実際には何も変更せず、手順だけ確認できる）
  例: `DRYRUN=1 bash scripts/00-preflight.sh forge.vars`
- 動作がおかしいときは `bash scripts/99-health-check.sh forge.vars` で健全性チェック
- それでも解決しない場合は `PLAYBOOK.md` の「重要な落とし穴」節を確認

## 所要目安
Step 0 の前提が揃っていれば、構築自体は 30〜60分程度です。
