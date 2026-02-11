# Neovim再構築 要件定義（ドラフト v2）

## 1. 背景
- 既存設定（`nvim/`）は不完全なため、Neovim設定を0から再構築する。
- 新規環境検証は `NVIM_APPNAME=tmp nvim` で実施可能。
- Neovim本体リポジトリへのシンボリックリンク `neovim -> /home/nag/ghq/github.com/neovim/neovim/` があるため、一次情報として `neovim/runtime/doc/` を参照できる。

## 2. 既知の必須方針（確定）
- プラグイン管理は `lazy.nvim` を採用する。
- LSP / DAP のツールインストール管理は `mason.nvim` を採用する。
- LSPクライアント設定は Neovim標準API（`vim.lsp.config`, `vim.lsp.enable` など）を使用し、`neovim/nvim-lspconfig` は使わない。
- 実行環境で読み込むプラグインを分離する。
  - CLI起動時
  - VSCode Neovim拡張バックエンド起動時（不要プラグインを読み込まない）
- 新構成は `nvim-refactor/` ディレクトリに新規作成する（既存 `nvim/` は当面保持）。

## 3. 対応言語（初期）
- JavaScript
- TypeScript
- Python
- Lua
- Bash
- 将来、Go / Rust などの言語追加を想定し、拡張しやすい構成にする。

## 4. フォーマット方針（確定済み）
- フォーマット設定は 0 から再設計する。
- TypeScript（およびJS系）の基本方針:
  1. 作業リポジトリ内に `prettier` / `eslint` の設定があれば利用候補にする。
  2. `biome` 設定ファイルがあれば `biome` を優先する。
  3. 何もなければデフォルトフォーマッタとして `biome` を使用する。
- フォールバック用の `biome` デフォルト設定ファイルを本リポジトリに含める。
- `biome` 設定ファイルにバージョン記述が必要なため、`mason` で導入する `biome` バージョンは固定する。
  - 指定: 現行最新版
  - 2026-02-11 時点の確認結果: `2.3.14`（mason-registry / GitHub Releases）
- Pythonのフォーマットには `ruff` を使用する。

## 5. 既存実装の把握（不完全設定の現状）
- エントリポイントは `nvim/init.lua`。
- 現在も `utils.env.is_vscode`（`vim.g.vscode == 1`）で分岐している。
- `lazy.nvim` ブートストラップは実装済み（`nvim/lua/plugins/lazyvim/bootstrap.lua`）。
- ただし現状プラグイン一覧に `neovim/nvim-lspconfig` と `williamboman/mason-lspconfig.nvim` が含まれており、今回方針と不一致。
- LSP設定は `nvim/lua/plugins/ide/masonconfig.lua` で `vim.lsp.config.*` を使い始めているが、構成が過渡的。
- DAP設定は `nvim/lua/plugins/ide/dapconfig.lua` に分離されている。
- 未解決TODO/FIXMEあり（`core/keymap.lua`, `commands/removeHtmlAttributes.lua`, `plugins/cli/treesitter.lua`, `plugins/ide/lspsaga.lua` など）。

## 6. VSCodeバックエンド時の除外方針（既存実装ベース）
既存 `nvim/lua/plugins/lazyvim/loadplugs.lua` の `cli_only_plugins` を基準に、VSCodeバックエンドでは以下を無効化する。
- LSP/UI: `mason.nvim`, `lspsaga.nvim`, `fidget.nvim`
- 構文/補完: `nvim-treesitter`, `nvim-cmp` 系
- DAP: `nvim-dap`, `mason-nvim-dap`, `nvim-dap-ui`, `vscode-js-debug`, `nvim-dap-vscode-js`
- UI拡張: `lualine.nvim`, `bufferline.nvim`, `nvim-web-devicons`, `hlchunk.nvim`
- 操作補助: `fzf-lua`, `vim-tmux-navigator`, `suda.vim`

## 7. 再構築のスコープ案
- 最小構成から段階導入する。
  1. 起動基盤（`init.lua`, options, keymaps, lazy bootstrap）
  2. 環境分岐（CLI / VSCode）
  3. LSP基盤（Neovim標準API + mason）
  4. DAP基盤（mason + nvim-dap系）
  5. 補完・UI・補助プラグイン
- 既存コードの流用は必要最小限にし、仕様が曖昧な箇所は新設計を優先する。

## 8. 追加確定事項
1. JS/TSの優先順位
- `biome` と `prettier` / `eslint` が同居する場合は `biome` を最優先とする。

2. DAPアダプタ方針
- JavaScript / TypeScript: `js-debug-adapter`（`microsoft/vscode-js-debug`）
- Python: `debugpy`
- Lua: `local-lua-debugger-vscode`
- Bash: `bash-debug-adapter`

3. UIとキーマップ
- テーマは既存どおり `iceberg.vim` を維持する。
- キーマップは既存維持とし、無駄・不完全なキーマップのみ削除する。

4. 対応OS
- 初期対応OS: ネイティブUbuntu / WSL上のUbuntu / macOS

## 9. 合意後に作成する成果物（予定）
- 構成設計書（ディレクトリ構造、責務分離、ロード順）
- プラグイン採用一覧（CLI/VSCode別）
- LSP/DAPサーバー管理方針（mason設定）
- 最小実装タスクリスト（フェーズ分割）
