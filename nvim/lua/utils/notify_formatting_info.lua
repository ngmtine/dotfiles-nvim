local get_js_config = require("utils/get_js_config")

-- プロジェクトの設定ファイルに基づいて通知
local notify_formatting_info = function(bufnr)
    local js_config = get_js_config(bufnr)
    local msg = ""

    -- メッセージ作成
    if js_config.biome ~= nil then
        if js_config.eslint ~= nil then
            -- biomeかつeslint
            msg = "Format: " .. js_config.biome .. " Lint: " .. js_config.eslint
        else
            -- biome単体
            msg = "Format & Lint: " .. js_config.biome
        end
    elseif js_config.prettier ~= nil then
        if js_config.eslint ~= nil then
            -- prettierかつeslint
            msg = "Format: " .. js_config.prettier .. " Lint: " .. js_config.eslint
        else
            -- prettier単体
            msg = "Format: " .. js_config.prettier
        end
    elseif js_config.eslint ~= nil then
        -- eslint単体（そんな場合ある？）
        msg = "Warning!! eslint単体だよ！そんな場合ある？？"
    else
        -- デフォルト設定（prettierを適用）
        msg = "Format: " -- .. js_config.prettier
    end

    -- vim.notify(msg, vim.log.levels.INFO)
    vim.notify(msg)
end

return notify_formatting_info
