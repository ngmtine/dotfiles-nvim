local M = {}

function M.setup()
  -- 全サーバー共通設定
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = capabilities,
  })

  -- サーバー個別設定（nvim-lspconfigのデフォルトへの上書きのみ）
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  })

  vim.lsp.config("ts_ls", {
    root_markers = { "package.json", "tsconfig.json", ".git" },
  })

  vim.lsp.config("pyright", {
    root_markers = { "pyproject.toml", "setup.py", ".git" },
  })

  vim.lsp.config("bashls", {
    filetypes = { "sh", "bash", "zsh" },
  })

  vim.lsp.config("biome", {
    root_markers = { "biome.json", "biome.jsonc", ".git" },
  })
end

return M
