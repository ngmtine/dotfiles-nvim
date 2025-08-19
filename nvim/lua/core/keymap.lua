-- keymap
vim.keymap.set("n", "<tab>", ":bn<cr>")
vim.keymap.set("n", "<s-tab>", ":bp<cr>")
vim.keymap.set("n", "<s-y>", "y$")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "<c-a>", "<c-o>^")
vim.keymap.set("i", "<c-e>", "<esc>$i<right>")
vim.keymap.set("i", "<c-k>", "<esc><right>d$a")
vim.keymap.set("n", "U", "<c-r>", { desc = "Redo" })
vim.keymap.set("n", "<", "<<")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "<c-l>", ":<c-u>nohlsearch<cr><c-l>") -- 検索ハイライトクリア
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")
vim.keymap.set("n", "*", "*N")
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true }) -- x削除はブラックホールレジスタ

-- map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- leader keymap
vim.keymap.set("n", "<Leader>rep", '"_dw"+P')
vim.keymap.set("v", "<Leader>rep", '"_d"+P')
vim.keymap.set("n", "<Leader>a", "ggVG")

-- バッファ操作系
vim.keymap.set("n", "<c-w>n", ":vnew<cr>", { desc = "右ウィンドウに新規バッファ" })

-- TODO: 修正する
local function move_buffer_to_right()
    local win_count = #vim.api.nvim_list_wins() -- nvim_list_wins() はテーブルを返す関数 #は長さ演算子
    if win_count == 1 then
        -- ウィンドウが1つの場合は、空バッファ開いて移動
        vim.cmd("vnew")
        vim.cmd("wincmd H")
        vim.cmd("wincmd l")
    else
        -- 複数ウィンドウがある場合は、現在のウィンドウを右端に移動
        vim.cmd('wincmd L')
    end
end

local function move_buffer_to_left()
    local win_count = #vim.api.nvim_list_wins()
    if win_count == 1 then
        -- ウィンドウが1つの場合は、空バッファを開いて左に移動
        vim.cmd("vnew")
        vim.cmd("wincmd L")
        vim.cmd("wincmd h")
    else
        -- 複数ウィンドウがある場合は、現在のウィンドウを左端に移動
        vim.cmd('wincmd H')
    end
end

-- shift+alt+h, shift+alt+l で現在のバッファを左右ウィンドウに移動
vim.keymap.set("n", "<s-a-l>", move_buffer_to_right, { desc = "現在のバッファを右ウィンドウに移動" })
vim.keymap.set("n", "<s-a-h>", move_buffer_to_left, { desc = "現在のバッファを左ウィンドウに移動" })
