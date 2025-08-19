--- 安全にモジュールを require し、結果またはエラー情報を返す
--- @param module string 要求するモジュール名
--- @return boolean success 成功したかどうか
--- @return any result 成功時はモジュールの内容、失敗時はエラー情報
local function safe_require(module)
    local ok, result = pcall(require, module)

    -- 失敗した場合、エラー通知
    if not ok then
        local msg = string.format("[safe_require] Error requiring module '%s':\n%s", module, tostring(result))
        vim.notify(msg, vim.log.levels.WARN, { title = "Module Load Error" })
        return false, result
    end

    -- 成功した場合、true と require された内容を返す
    return true, result
end

return safe_require
