local M = {}

function M.setup()
  vim.g.tmux_navigator_no_mappings = 1
  vim.g.tmux_navigator_save_on_switch = 2

  local opts = { silent = true }
  vim.keymap.set("n", "<A-h>", ":TmuxNavigateLeft<cr>", opts)
  vim.keymap.set("n", "<A-j>", ":TmuxNavigateDown<cr>", opts)
  vim.keymap.set("n", "<A-k>", ":TmuxNavigateUp<cr>", opts)
  vim.keymap.set("n", "<A-l>", ":TmuxNavigateRight<cr>", opts)
end

return M
