local M = {}

function M.setup(env)
  local plugins = {
    { "cocopon/iceberg.vim", priority = 1000, lazy = false, config = function() require("plugins.shared.theme").setup() end },
    { "preservim/nerdcommenter", config = function() require("plugins.shared.comment").setup() end },
  }

  if not env.is_vscode then
    vim.list_extend(plugins, {
      { "williamboman/mason.nvim", config = function() require("plugins.lsp.init").setup_mason() end },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function() require("plugins.lsp.init").setup_tools() end,
      },
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function() require("plugins.cli.treesitter").setup() end },
      { "hrsh7th/nvim-cmp", config = function() require("plugins.cli.cmp").setup() end },
      { "hrsh7th/cmp-nvim-lsp" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-lualine/lualine.nvim", config = function() require("plugins.cli.ui").setup_lualine() end },
      { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("plugins.cli.ui").setup_bufferline() end },
      { "ibhagwan/fzf-lua", config = function() require("plugins.cli.fzf").setup() end },
      { "christoomey/vim-tmux-navigator" },
      { "lambdalisue/suda.vim" },
      { "mfussenegger/nvim-dap", config = function() require("plugins.dap.init").setup() end },
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    })
  end

  require("lazy").setup(plugins, {
    ui = { border = "rounded" },
  })

  if not env.is_vscode then
    require("plugins.lsp.init").setup_lsp()
  end
end

return M
