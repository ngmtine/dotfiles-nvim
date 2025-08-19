-- 起動開始時刻を取得
vim.g.start_time = vim.loop.hrtime()

local U = require("utils")

-- LazyVim
require("plugins.lazyvim.bootstrap")
require("plugins.lazyvim.loadplugs")

U.safe_require_all("core")
U.safe_require_all("commands")
U.safe_require_all("plugins/general")
U.safe_require_all("plugins/cli")
U.safe_require_all("plugins/ide")

-- 起動時刻を表示するautocmd
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Startup", { clear = true }),
    pattern = "*",
    once = true,
    callback = function()
        -- 開始時刻と終了時刻の差分とってナノ秒からミリ秒に
        local start_time = vim.g.start_time
        local end_time = vim.loop.hrtime()
        local elapsed_ms = (end_time - start_time) / 1000000

        -- 結果を通知
        vim.notify(
            string.format("🚀 Neovim loaded in %.2f ms", elapsed_ms),
            vim.log.levels.INFO,
            { title = "Startup Time" }
        )

        vim.g.start_time = nil
    end,
})
