vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_save_on_switch = 2

vim.keymap.set("n", "<A-h>", ":TmuxNavigateLeft<cr>", {
    silent = true
})
vim.keymap.set("n", "<A-j>", ":TmuxNavigateDown<cr>", {
    silent = true
})
vim.keymap.set("n", "<A-k>", ":TmuxNavigateUp<cr>", {
    silent = true
})
vim.keymap.set("n", "<A-l>", ":TmuxNavigateRight<cr>", {
    silent = true
})
