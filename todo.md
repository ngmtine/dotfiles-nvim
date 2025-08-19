# Neovim設定 修正TODOリスト

## 修正すべき点

- [ ] **キーマップの重複と上書き**
  - `core/keymap.lua` と `plugins/cli/vim-tmux-navigator.lua` の両方で `<c-l>` がマッピングされている。
  - `vim-tmux-navigator.lua` の設定が意図せず上書きされ、Tmuxの右ペインへの移動が機能していないため修正する。

- [ ] **古いAPIの使用**
  - `plugins/ide/dapconfig.lua` で古い `vim.api.nvim_set_keymap` が使われている。
  - 他のファイルと一貫性を持たせるため、モダンな `vim.keymap.set` に統一する。

- [ ] **不要なコード（コメントアウト）**
  - `plugins/ide/dapconfig_js.lua` のほぼ全体がコメントアウトされている。
  - コードを完成させるか、不要であれば削除してクリーンアップする。

- [ ] **`goto`の使用**
  - `utils/safe_require_all.lua` で `goto` が使われている。
  - より可読性の高い `if/else` 構造にリファクタリングする。

- [ ] **未解決の `TODO` / `FIXME`**
  - 以下のファイルに残っている `TODO` と `FIXME`コメントの内容を確認し、対処する。
    - `commands/removeHtmlAttributes.lua`
    - `core/keymap.lua`
    - `plugins/cli/treesitter.lua`
