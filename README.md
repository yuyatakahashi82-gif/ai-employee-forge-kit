# ai-employee-forge

AI社員（[Hermes](https://github.com/NousResearch/hermes-agent) ベースの常駐エージェント）を
owner の Mac にゼロから構築する、エージェント非依存の配布プレイブック。

## 何ができるか
owner 専属の AI パートナー（デジタルツイン）を、owner 名義のログイン認証だけで（API課金ゼロの脳=ChatGPT Codex）構築し、
Discord 常駐・自動学習メモリ・自己保守（自動再起動）まで一通り立ち上げる。

## 前提
- macOS（Apple Silicon 想定）＋ Xcode CLT（`xcode-select --install`）
- owner 本人の ChatGPT(Plus)。Discord bot を立てる owner の Discord アカウント
- Claude Code か Codex 等、shell を実行できる AI エージェント（このプレイブックを実行する側）

## クイックスタート
1. `cp forge.vars.example forge.vars` し回答を埋める
2. `PLAYBOOK.md` の (B) に沿って `scripts/` を順に実行（まず `DRYRUN=1`）
3. `bash scripts/90-clean-exit-verify.sh forge.vars` が exit 0 を確認

## 運用ツール
- `scripts/99-health-check.sh forge.vars` 健全性チェック / `scripts/memory-review.sh forge.vars` メモリ棚卸し

## テスト
`./run-tests.sh`（外部依存なしの純 bash ハーネス）

## スコープ
単体 AI社員の構築まで。組織化（複数部署/役割）は対象外。
