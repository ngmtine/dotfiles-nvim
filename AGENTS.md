# Neovim設定リポジトリ 概要

## リポジトリの目的
このリポジトリは、Neovimの設定を行うためのものです。LazyVimをベースにカスタマイズされており、効率的な開発環境を提供します。

## 採用プラグイン
### UI
- **テーマ**: [iceberg.vim](https://github.com/cocopon/iceberg.vim) - 目に優しいカラースキーム
- **ステータスライン**: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - 情報豊富なステータスバー
- **バッファタブ**: [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - バッファのタブ表示
- **アイコン**: [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - ファイルタイプのアイコン表示

### 編集 & IDE
- **LSP**: [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - 言語サーバー連携によるコード解析
- **補完**: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 高速な自動補完
- **シンタックスハイライト**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 正確な構文ハイライト
- **デバッグ**: [nvim-dap](https://github.com/mfussenegger/nvim-dap) - デバッガー統合
- **ファジーファインダー**: [fzf-lua](https://github.com/ibhagwan/fzf-lua) - ファイル/バッファ検索

### ユーティリティ
- **コメントアウト**: [nerdcommenter](https://github.com/preservim/nerdcommenter) - スマートなコメント操作
- **Tmux連携**: [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Tmuxとのシームレスな移動
- **Sudo編集**: [suda.vim](https://github.com/lambdalisue/suda.vim) - 権限昇格でのファイル編集

## 構成
- **`nvim/init.lua`**: メインのエントリーポイント。起動時間を計測し、各モジュールを読み込む。
- **`lua/core/`**: Neovimの基本設定とキーマップ。
- **`lua/commands/`**: カスタムユーザーコマンド（例: copyPath, pipeBuffer, removeHtmlAttributes）。
- **`lua/plugins/`**: プラグイン設定。lazyvim, general, cli, ide のカテゴリ別。
- **`lua/utils/`**: 共通のユーティリティ関数。
- **その他**: `install.sh` (インストールスクリプト), `nvim-launcher.sh` (起動スクリプト), `readme.md` (説明), `todo.md` (タスクリスト)。

## 起動処理
- LazyVimのブートストラップとプラグイン読み込み。
- VSCode拡張機能環境では一部プラグインを除外。
- 起動時間を測定し、通知で表示。

## TODO / 修正点
以下のファイルに未解決の `TODO` / `FIXME` コメントがあります。対応が必要です：
- `commands/removeHtmlAttributes.lua`
- `core/keymap.lua`
- `plugins/cli/treesitter.lua`
- `plugins/ide/javascript.lua`
- `plugins/ide/shell.lua`
- `plugins/ide/lspsaga.lua`