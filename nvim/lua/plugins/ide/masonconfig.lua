require("mason").setup({
    ensure_installed = {
        "beautysh",
    },
    -- automatic_installation = true,
    ui = { border = "rounded" },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ts_ls",
        "efm", -- biome, prettier, eslint用
        "bashls",
    },
    automatic_installation = true,
})
