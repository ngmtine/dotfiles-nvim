local U = require("utils")
local keymap_lsp = require("core.keymap")
local lspconfig = require("lspconfig")

-- efmのsettingsテーブルを動的に構築する関数
local function build_efm_settings()
    -- 返却値
    local settings = {
        version = 2,
        rootMarkers = { ".git", "package.json" },
        lintDebounce = "500ms",
        languages = {},
    }

    local format_settings = {}
    local bufnr = vim.api.nvim_get_current_buf()
    local js_config = U.get_js_config(bufnr)

    -- 現在のバッファ情報に基づいてフォーマッタ, リンタ設定を決定
    if js_config.biome_config then
        if js_config.eslint_config then
            -- biomeかつeslint
            -- TODO: あとで書く
        else
            -- biome単体
            table.insert(format_settings, {
                formatCommand = "biome format --stdin-file-path ${INPUT}",
                formatStdin = true,
            })
            table.insert(format_settings, {
                lintCommand = "biome lint ${FILENAME} --no-errors-on-unmatched",
                lintStdin = false,
                lintFormats = { "%f:%l:%c - %t: %m", "%f:%l:%c %t: %m" },
            })
        end
    elseif js_config.prettier_config then
        if js_config.eslint_config then
            -- prettierかつeslint
            table.insert(format_settings, {
                formatCommand = "prettier --stdin-filepath ${INPUT}",
                formatStdin = true,
            })
            table.insert(format_settings, {
                lintCommand = "eslint --format=compact --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m [%t/%e]", "%f:%l:%c: %m" },
            })
        else
            -- prettier単体
            table.insert(format_settings, {
                formatCommand = "prettier --stdin-filepath ${INPUT}",
                formatStdin = true,
            })
        end
    elseif js_config.eslint_config then
        -- eslint単体（そんな場合ある？）
        -- TODO: あとで書く
    else
        -- デフォルト設定（prettierを適用）
        table.insert(format_settings, {
            formatCommand = "prettier --stdin-filepath ${INPUT}",
            formatStdin = true
        })
    end

    -- 各言語に構築したツールのリストを割り当て
    settings.languages["javascript"] = format_settings
    settings.languages["typescript"] = format_settings
    settings.languages["javascriptreact"] = format_settings
    settings.languages["typescriptreact"] = format_settings

    -- JSON設定
    settings.languages["json"] = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true }
    }

    return settings
end

-- 共通on_attach関数
local on_attach = function(client, bufnr)
    local msg = string.format("[lspconfig_js] LSP client '%s' attached to buffer %d", client.name or "unknown", bufnr or "empty buffer")
    vim.notify(msg)
end

-- フォーマット対象ファイルタイプ
-- local target_filetypes = {
--     javascript = true,
--     typescript = true,
--     javascriptreact = true,
--     typescriptreact = true,
--     json = true,
-- }

-- js, tsのlsp設定
lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- 共通on_attach
        on_attach(client, bufnr)

        -- キーマップ
        keymap_lsp(bufnr)

        -- ts_lsのフォーマット機能を無効化（efmとの競合回避）
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- 保存時フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("EfmFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                -- local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                -- if not target_filetypes[filetype] then
                --     return
                -- end
                U.notify_formatting_info(bufnr)
                vim.lsp.buf.format({
                    filter = function(c) return c.name == "efm" end, -- フォーマットはefmに一任
                    async = false                                    -- 非同期にするとなんかバグるので無効化
                })
            end,
        })
    end
})

-- efmのlsp設定（js, ts以外のファイルで実行させないために、この場所で指定）
lspconfig.efm.setup({
    -- on_attach(client, bufnr),                -- 共通on_attach
    settings = build_efm_settings(), -- プロジェクトがbiome, prettier, eslintのどれを採用しているかによって動的に設定
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = false,
        documentHighlight = false,
        hover = false,
        completion = false,
    },
})
