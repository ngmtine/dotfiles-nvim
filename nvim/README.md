# nvim-refactor

Neovim `v0.11.6` 向けの再構築設定です。

## 起動方法

- このリポジトリを `XDG_CONFIG_HOME` に指定して起動:

```bash
XDG_CONFIG_HOME=/home/nag/ghq/github.com/ngmtine/dotfiles-nvim NVIM_APPNAME=nvim-refactor nvim
```

- クリーン起動確認（headless）:

```bash
XDG_CONFIG_HOME=/home/nag/ghq/github.com/ngmtine/dotfiles-nvim NVIM_APPNAME=nvim-refactor nvim --headless "+qa"
```

## 方針

- プラグイン管理: `lazy.nvim`
- LSP設定: Neovim標準API（`vim.lsp.config`, `vim.lsp.enable`）
- ツール管理: `mason.nvim` + `mason-tool-installer.nvim`
- CLIとVSCodeバックエンドでプラグイン読み込みを分離

## 対応言語（初期）

- JavaScript / TypeScript
- Python
- Lua
- Bash

## フォーマット

- JS/TS優先順位:
  1. `biome.json` / `biome.jsonc`
  2. Prettier / ESLint 設定
  3. フォールバック `nvim-refactor/biome/biome.json`
- Python: `ruff format`
- 保存時フォーマットは `LspAttach` 後のバッファで有効
- 手動フォーマット: `<leader>f`

## キーマップ移行

既存キーマップをベースに維持し、旧設定でTODO/FIXMEだった不完全なバッファ移動キーマップ（`<s-a-h>`, `<s-a-l>`）は削除済みです。
