# nvim-refactor 設計書

## 1. 目的
- 既存 `nvim/` とは独立して、`nvim-refactor/` に新しいNeovim設定を構築する。
- Neovim `v0.11.6` の標準LSP API（`vim.lsp.config`, `vim.lsp.enable`）を中心にする。
- CLI起動とVSCodeバックエンド起動で、読み込むプラグインを分離する。
- 初期対応言語（JS/TS/Python/Lua/Bash）を安定運用できる最小構成を先に完成させる。

## 2. 非目的
- 既存 `nvim/` の完全互換は最優先にしない。
- 初期段階でGo/Rust等を実装しない（拡張可能な構造だけ先に用意）。

## 3. ディレクトリ構成（提案）

```text
nvim-refactor/
  init.lua
  lua/
    core/
      options.lua
      keymaps.lua
      autocmds.lua
      env.lua
    config/
      lazy.lua
      plugins.lua
    plugins/
      shared/
        theme.lua
        comment.lua
      cli/
        ui.lua
        treesitter.lua
        cmp.lua
        fzf.lua
      lsp/
        init.lua
        servers.lua
        attach.lua
        format.lua
      dap/
        init.lua
        adapters.lua
        keymaps.lua
    util/
      fs.lua
      notify.lua
  after/
    ftplugin/
      lua.lua
      python.lua
      typescript.lua
      javascript.lua
  biome/
    biome.json
```

## 4. 起動とロード順
1. `init.lua`
- `core.env` を最初に読み込み（`vim.g.vscode == 1` 判定）
- `core.options`, `core.keymaps`, `core.autocmds` を読み込み
- `config.lazy` で `lazy.nvim` をbootstrap
- `config.plugins` でプラグイン仕様を生成し `lazy.setup()`

2. `config.plugins`
- `shared` プラグインは常時読み込み
- `if not env.is_vscode` の時のみ `cli`, `lsp`, `dap` プラグイン群を追加

3. LSP/DAP 初期化
- CLI時のみ `plugins/lsp/init.lua` と `plugins/dap/init.lua` を実行

## 5. プラグイン採用方針

### 5.1 共通（CLI / VSCode）
- `folke/lazy.nvim`（必須）
- `cocopon/iceberg.vim`
- `preservim/nerdcommenter`
- 必要最低限のユーティリティ（例: `nvim-lua/plenary.nvim`）

### 5.2 CLI専用
- LSP/DAP管理: `williamboman/mason.nvim`
- DAP: `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`
- JS/TS DAP: `microsoft/vscode-js-debug`（mason経由の `js-debug-adapter` を利用）
- Python DAP: `debugpy`
- Lua DAP: `local-lua-debugger-vscode`
- Bash DAP: `bash-debug-adapter`
- 補完: `hrsh7th/nvim-cmp`, `hrsh7th/cmp-nvim-lsp`
- 構文: `nvim-treesitter/nvim-treesitter`
- UI: `nvim-lualine/lualine.nvim`, `akinsho/bufferline.nvim`, `nvim-tree/nvim-web-devicons`
- 補助: `ibhagwan/fzf-lua`, `christoomey/vim-tmux-navigator`, `lambdalisue/suda.vim`

### 5.3 VSCodeバックエンドで無効化
- `mason.nvim` 含むLSP/DAP関連一式
- `nvim-cmp`, `treesitter`, `lualine`, `bufferline`, `fzf-lua` などCLI向けUI/補助

## 6. LSP設計（Neovim標準API）

## 6.1 基本原則
- `nvim-lspconfig` は使わない。
- `vim.lsp.config.<server_name> = { ... }` を定義し、`vim.lsp.enable({...})` で有効化する。

## 6.2 初期サーバー
- `lua_ls`
- `ts_ls`
- `pyright`（診断中心）
- `bashls`
- `biome`（JS/TSフォーマット/診断の主担当）

## 6.3 attach時処理
- 共通LSPキーマップを設定（既存維持ベース）
- 競合回避:
  - `ts_ls` のformat capabilityは無効化
  - 実フォーマットは `biome` / `ruff` 優先制御で実行

## 7. フォーマット設計

## 7.1 JS/TS
優先順位（確定）:
1. `biome.json` / `biome.jsonc` があれば `biome`
2. `prettier` / `eslint` 設定があればそれらを使用
3. 何もなければリポジトリ内のフォールバック `biome/biome.json` を使って `biome`

判定対象ファイル（初期案）:
- biome: `biome.json`, `biome.jsonc`
- prettier: `.prettierrc`, `.prettierrc.json`, `.prettierrc.js`, `.prettierrc.cjs`, `prettier.config.js`, `prettier.config.cjs`
- eslint: `.eslintrc`, `.eslintrc.json`, `.eslintrc.js`, `.eslintrc.cjs`, `eslint.config.js`, `eslint.config.cjs`, `eslint.config.mjs`

## 7.2 Python
- `ruff format` を使用する。
- `ruff` 未導入時はmason導入版を優先して実行する。

## 7.3 biomeバージョン固定
- 方針: 現行最新版を採用
- 2026-02-11 時点: `2.3.14`
- `mason` インストール時に `biome@2.3.14` を指定し、`biome/biome.json` の `"$schema"` / `"extends"` と整合を取る。

## 8. DAP設計
- JS/TS: `js-debug-adapter`
- Python: `debugpy`
- Lua: `local-lua-debugger-vscode`
- Bash: `bash-debug-adapter`

実装指針:
- `plugins/dap/adapters.lua` にアダプタ定義を集約
- `plugins/dap/keymaps.lua` に既存Dapキーマップを移植
- `dap-ui` の自動open/close listenerは現行踏襲

## 9. キーマップ移行方針
- 既存キーマップは原則維持。
- 削除対象:
  - TODO/FIXME付きで動作不安定なもの
  - 既存Neovim標準と衝突し、メリットが小さいもの
  - VSCodeバックエンドで意味がないCLI専用キーマップ

## 10. OS対応
初期対応OS:
- ネイティブUbuntu
- WSL上のUbuntu
- macOS

実装上の注意:
- クリップボード設定はOS判定で分岐
- 実行バイナリパス解決は `vim.fn.exepath` を優先

## 11. 実装フェーズ

### Phase 1: 土台
- `nvim-refactor/init.lua` と `core/*` を作成
- `lazy.nvim` bootstrap
- VSCode分岐のみ先に実装

### Phase 2: プラグイン分離
- `shared` / `cli` プラグイン分割
- テーマ・最低限UIを適用

### Phase 3: LSP
- `vim.lsp.config` ベースで5言語対応
- `LspAttach` でキーマップ・フォーマット制御

### Phase 4: Format
- JS/TSフォーマット判定実装
- Python `ruff format` 実装
- `biome/biome.json` フォールバック導入

### Phase 5: DAP
- 4アダプタ導入
- 既存Dapキーマップ移植

### Phase 6: 仕上げ
- 不要/不完全キーマップ削除
- Ubuntu/WSL/macOSで起動確認
- `NVIM_APPNAME=tmp nvim` でクリーン検証

## 12. 受け入れ条件
- CLI起動時にLSP/DAP/補完/UIが有効
- VSCodeバックエンド起動時にCLI専用プラグインがロードされない
- JS/TSで `biome` 優先ルールが機能する
- Pythonで `ruff format` が機能する
- 既存キーマップは大半維持しつつ、不完全項目のみ整理されている
