require("lspsaga").setup({
    -- パンくずリスト
    symbol_in_winbar = {},

    -- コードアクション
    -- :Lspsaga code_action
    code_action = {
        keys = {
            quit = { "q", "<Esc>" },
        },
    },

    -- 実装定義と型参照の表示
    -- :Lspsaga peek_definition
    -- :Lspsaga peek_type_definition
    definition = {
        width = 1.0, -- FIXME: 刻むと左に寄る
        height = 0.7,
        keys = {
            edit = "e",
            vsplit = "<leader>v", -- 右に開く
            split = "<leader>h",  -- 下に開く
            tabe = "<leader>t",
            quit = { "q", "<Esc>" },
        },
    },

    -- 診断メッセージの表示
    -- :Lspsaga diagnostic_jump_next
    -- :Lspsaga diagnostic_jump_prev
    diagnostic = {
        keys = {
            quit = { "q", "<ESC>" }
        }
    },

    -- 定義、参照、実装の表示
    finder = {},

    -- コードアクションのヒント
    lightbulb = {
        sign = false -- 左側にアイコンを描画する機能であるが、ガタつく
    },
})

vim.keymap.set("n", "<leader>j", "<cmd>Lspsaga term_toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { noremap = true, silent = true })
