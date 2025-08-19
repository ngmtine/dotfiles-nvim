local get_project_root = require("utils/get_project_root")
local find_formatter_config = require("utils/find_formatter_config")

local filenames = {
    biome = { "biome.json" },
    prettier = { ".prettierrc", ".prettierrc.json" },
    eslint = { ".eslintrc", ".eslintrc.json", "eslint.config.js" },
    -- tsconfig = { "tsconfig.json" },
    -- package = { "package.json" },
    -- webpack = { "webpack.config.js", "webpack.config.ts" },
    -- next = { "next.config.ts" },
}

-- js, tsの設定ファイルをフルパスで返す関数（フォーマッタの指定用にしか使ってない）
local function get_js_config(bufnr)
    local js_config = { biome = nil, prettier = nil, eslint = nil, tsconfig = nil }
    local root_dir = get_project_root(bufnr)

    if root_dir then
        js_config.biome = find_formatter_config(filenames.biome, bufnr)
        js_config.prettier = find_formatter_config(filenames.prettier, bufnr)
        js_config.eslint = find_formatter_config(filenames.eslint, bufnr)
        -- js_config.tsconfig = find_formatter_config(filenames.tsconfig, bufnr)
        -- js_config.package = find_formatter_config(filenames.package, bufnr)
        -- js_config.webpack = find_formatter_config(filenames.webpack, bufnr)
        -- js_config.next = find_formatter_config(filenames.next, bufnr)
    end

    -- 見つからない場合は ~/.config/nvim から探す
    -- local nvim_config_root = vim.fn.stdpath("config")
    -- if not js_config.biome then
    --     js_config.biome = find_formatter_config(filenames.biome, bufnr, nvim_config_root)
    -- end
    -- if not js_config.prettier then
    --     js_config.prettier = find_formatter_config(filenames.prettier, bufnr, nvim_config_root)
    -- end
    -- if not js_config.eslint then
    --     js_config.eslint = find_formatter_config(filenames.eslint, bufnr, nvim_config_root)
    -- end

    return js_config
end

return get_js_config
