## 採用プラグイン

*   **UI:**
    *   テーマ: [iceberg.vim](https://github.com/cocopon/iceberg.vim)
    *   ステータスライン: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
    *   バッファタブ: [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
    *   アイコン: [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
*   **編集 & IDE:**
    *   **LSP:** [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) による言語サーバー連携
    *   **補完:** [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) による自動補完
    *   **シンタックスハイライト:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) による高速で正確なハイライト
    *   **デバッグ:** [nvim-dap](https://github.com/mfussenegger/nvim-dap) によるデバッグ機能
    *   **ファジーファインダー:** [fzf-lua](https://github.com/ibhagwan/fzf-lua) によるファイルやバッファの検索
*   **ユーティリティ:**
    *   **コメントアウト:** [nerdcommenter](https://github.com/preservim/nerdcommenter)
    *   **Tmux連携:** [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
    *   **Sudo編集:** [suda.vim](https://github.com/lambdalisue/suda.vim)

## 構成

-   `init.lua`: メインのエントリーポイント
-   `lua/core/`: Neovimのコア設定とキーマップ
-   `lua/plugins/`: プラグイン設定（cli, general, ide のカテゴリ別）
-   `lua/commands/`: カスタムユーザーコマンド
