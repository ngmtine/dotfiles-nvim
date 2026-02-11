local M = {}

local function resolve_bin(bin_name)
  local path = vim.fn.exepath(bin_name)
  if path ~= "" then
    return path
  end

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. bin_name
  if vim.fn.executable(mason_bin) == 1 then
    return mason_bin
  end

  return nil
end

local function with_root_fallback(markers)
  return function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
      on_dir(vim.fn.getcwd())
      return
    end

    local root = vim.fs.root(name, markers)
    if root then
      on_dir(root)
      return
    end

    on_dir(vim.fs.dirname(name))
  end
end

function M.setup()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local lua_ls = resolve_bin("lua-language-server")
  local ts_ls = resolve_bin("typescript-language-server")
  local pyright = resolve_bin("pyright-langserver")
  local bashls = resolve_bin("bash-language-server")
  local biome = resolve_bin("biome")

  vim.lsp.config.lua_ls = {
    cmd = lua_ls and { lua_ls },
    capabilities = capabilities,
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    root_dir = with_root_fallback({ ".luarc.json", ".luarc.jsonc", ".git" }),
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  }

  vim.lsp.config.ts_ls = {
    cmd = ts_ls and { ts_ls, "--stdio" },
    capabilities = capabilities,
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
    root_dir = with_root_fallback({ "package.json", "tsconfig.json", ".git" }),
  }

  vim.lsp.config.pyright = {
    cmd = pyright and { pyright, "--stdio" },
    capabilities = capabilities,
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
    root_dir = with_root_fallback({ "pyproject.toml", "setup.py", ".git" }),
  }

  vim.lsp.config.bashls = {
    cmd = bashls and { bashls, "start" },
    capabilities = capabilities,
    filetypes = { "sh", "bash", "zsh" },
    root_markers = { ".git" },
    root_dir = with_root_fallback({ ".git" }),
  }

  vim.lsp.config.biome = {
    cmd = biome and { biome, "lsp-proxy" },
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
    root_markers = { "biome.json", "biome.jsonc", "package.json", ".git" },
    root_dir = with_root_fallback({ "biome.json", "biome.jsonc", "package.json", ".git" }),
  }

  local enabled = {}
  if lua_ls then table.insert(enabled, "lua_ls") else vim.notify("lua-language-server not found", vim.log.levels.WARN) end
  if ts_ls then table.insert(enabled, "ts_ls") else vim.notify("typescript-language-server not found", vim.log.levels.WARN) end
  if pyright then table.insert(enabled, "pyright") else vim.notify("pyright-langserver not found", vim.log.levels.WARN) end
  if bashls then table.insert(enabled, "bashls") else vim.notify("bash-language-server not found", vim.log.levels.WARN) end
  if biome then table.insert(enabled, "biome") end

  vim.lsp.enable(enabled)
end

return M
