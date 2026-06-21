# clean-exit チェックリスト（owner専属の最終確認）

- [ ] `90-clean-exit-verify.sh forge.vars` が exit 0（構築者痕跡なし）
- [ ] `auth.json` の providers が owner名義のログインのみ（構築者のtoken/API無し）
- [ ] 構築者の git identity / lkr / SSH 鍵が残っていない
- [ ] `~/.ssh/authorized_keys` から構築者の一時公開鍵を削除した
- [ ] 対象機の「リモートログイン」を OFF に戻した
- [ ] 構築者は対象機の Wi-Fi/LAN から離脱
