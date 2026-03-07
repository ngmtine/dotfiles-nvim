-- cliとvscodeとで共通して読み込むプラグイン
local plugins = {
    { "nvim-lua/plenary.nvim" }, -- ユーティリティライブラリ なんかの依存
    { "monaqa/dial.nvim" }, -- c-a, c-x の強化
    { "norcalli/nvim-colorizer.lua" }, -- カラーコードに背景色つける
    { "preservim/nerdcommenter" }, -- コメントアウト
    { "machakann/vim-sandwich" }, -- vim-surrond的なやつ
    { "cohama/lexima.vim" }, -- 括弧補完
    { "cocopon/iceberg.vim" }, -- カラースキーム
}

-- vscodeでは読み込まないプラグイン
local cli_only_plugins = {
    -- lsp関係
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "nvimdev/lspsaga.nvim", -- lspのUI
        event = { "LspAttach" },
    },

    { "nvim-treesitter/nvim-treesitter" }, -- treesitter（hlchunk, lspsagaの依存）
    { "nvim-treesitter/nvim-treesitter-textobjects" }, -- treesitterでテキストオブジェクトを拡張するやつ
    { "j-hui/fidget.nvim" }, -- lspの状態通知
    { "hrsh7th/nvim-cmp" }, -- 補完
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline" },

    -- dap
    { "mfussenegger/nvim-dap" }, -- dap
    { "jay-babu/mason-nvim-dap.nvim" }, -- masonでdapを使うやつ
    { "rcarriga/nvim-dap-ui" }, -- dapのui
    { "nvim-neotest/nvim-nio" }, -- 非同期APIユーティリティ（nvim-dap-uiの依存）
    { "kyazdani42/nvim-web-devicons" }, -- アイコン（lualine, lspsaga, bufferlineの依存）
    { "nvim-lualine/lualine.nvim" }, -- ステータスライン
    { "christoomey/vim-tmux-navigator" }, -- nvimとtmuxのペイン移動
    { "lambdalisue/suda.vim" }, -- sudo
    {
        "shellRaining/hlchunk.nvim", -- インデントとかの可視化
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    { "ibhagwan/fzf-lua" }, -- fuzzy finder
    { "akinsho/bufferline.nvim" }, -- バッファをタブエディタっぽく表示するやつ
    {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    {
        "mxsdev/nvim-dap-vscode-js", -- dap
        dependencies = { "mfussenegger/nvim-dap" },
    },
}

-- 最終的に読み込むプラグインリストの作成
local env = require("utils.env")
if not env.is_vscode then
    for _, additional in ipairs(cli_only_plugins) do
        table.insert(plugins, additional)
    end
end

-- プラグイン読み込み
require("lazy").setup(plugins, {
    ui = {
        border = "rounded", -- 枠線
        -- backdrop = 100 -- 効かない（wezterm）
    },
})
