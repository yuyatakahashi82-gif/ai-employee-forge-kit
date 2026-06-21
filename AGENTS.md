# AGENTS.md — ai-employee-forge

このリポジトリは AI社員構築の配布プレイブック。
手順は `PLAYBOOK.md` に従う。`forge.vars` を埋め、`scripts/` を順に実行し、
最後に `scripts/90-clean-exit-verify.sh forge.vars` を exit 0 で通す。
認証は owner 本人が入力し、構築者の鍵を残さない。
