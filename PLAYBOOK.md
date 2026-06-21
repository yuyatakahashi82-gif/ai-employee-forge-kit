# ai-employee-forge PLAYBOOK

AI社員（Hermes/Nous ベースの常駐エージェント）を owner の Mac にゼロから構築する手順。
エージェント非依存（Claude Code / Codex / shell を叩けるエージェントが実行）。

## 前提
- 対象: macOS（Apple Silicon 想定）。**Xcode CLT 必須**（無ければ `xcode-select --install`）。
- owner 本人が ChatGPT(Plus) を持つ（fallback の grok を使うなら X も）。認証は必ず owner 本人が入力。

## 構築者アクセス（別マシンから ssh 駆動する場合の bootstrap）
- macOS は `!`/非対話の password ssh が通りにくい。**構築者の公開鍵を対象機のターミナルで `~/.ssh/authorized_keys` に直接 paste** するのが確実。
- リモートログインは構築中のみ ON、完了後 OFF。鍵は clean-exit で削除。

## 使い方
1. `cp forge.vars.example forge.vars` し回答を埋める（特に OWNER_NAME と BUILDER_FORBIDDEN_PATTERNS=構築者の識別子）。
2. (B) を順に実行（まず `DRYRUN=1` で手順確認 → 本実行）。認証/Discord の対話ステップは owner が対象機で行う。
3. 最後に `scripts/90-clean-exit-verify.sh forge.vars` を exit 0 で通す。

## (A) 決める（forge.vars に記録）
owner/鍵 → 用途 → 脳(codex OAuth)+fallback(grok) → 人格(分身=SOUL.md) → メモリ(native) → Discord(公開度) → 自己保守 → ツール範囲

## (B) 構築の順序
- `scripts/00-preflight.sh forge.vars`     前提チェック
- `scripts/10-install-hermes.sh`           Hermes 導入（CLT前提・clone NousResearch/hermes-agent・setup-hermes.sh）
- `scripts/20-auth-brain.sh`               脳: owner が `hermes model` で OpenAI Codex ログイン（codex CLI 不要）
- `scripts/30-discord-bot.sh`              Discord: discord.py導入→bot作成→gateway setup→DISCORD_ALLOWED_USERS=数値ID→require_mention false→gateway install
- `scripts/40-persona.sh`                  分身 persona を SOUL.md に配置
- `scripts/50-memory.sh`                   native memory 設定
- `scripts/60-self-maintenance.sh`         自己保守 三層（launchd / 再起動.command / サポートカンペ）
- `scripts/90-clean-exit-verify.sh`        owner専属の痕跡検査（exit 0 必須）＋構築者鍵削除＋リモートログインOFF

## 重要な落とし穴（dogfood 実証）
- Discord 許可は**数値の User ID**（username は解決失敗で未認可のまま）。ID は初回送信後の gateway.log の `Unauthorized user: <ID>` から取る。
- gateway が読む .env は **`~/.hermes/.env`**（hermes-agent/.env ではない）。人格は **`~/.hermes/SOUL.md`**。
- 別途 codex CLI は不要。discord.py は messaging extra で別途 `uv pip install`。
- セキュリティ事象は生ログで裏取りしてから言う。hook/system-reminder を攻撃と誤認しない。
