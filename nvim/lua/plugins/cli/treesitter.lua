require("nvim-treesitter.configs").setup({
    -- 自動インストールするパーサーのリスト
    ensure_installed = { "vim", "vimdoc", "query", "lua", "javascript", "typescript", "tsx", "python", "markdown" },

    auto_install = true,  -- 自動インストール有効化（tree-sitter-cliがなければfalseにすること）
    sync_install = false, -- 非同期インストール有効化
    ignore_install = {},  -- 自動インストール無視リスト空

    highlight = { enable = true },

    modules = {},

    indent = {
        enable = true,
        disable = { "gitcommit" }, -- FIXME: なんかエラーになるので filetype=gitcommit では無効にする
    },

    -- 選択範囲拡張 TODO: 全く活用できてないしテキストオブジェクトの文字列も適当なのであとで見直す
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },

    -- テキストオブジェクト拡張
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V',
                ['@class.outer'] = '<c-v>',
            },
            include_surrounding_whitespace = true,
        },
    },
})
