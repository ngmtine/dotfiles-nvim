local get_project_root = require("utils/get_project_root")

-- 設定ファイルを現在のディレクトリから親ディレクトリに向かって検索
-- @param filenames (string|table) 検索するファイル名のリストまたは単一ファイル名
-- @param bufnr (number, optional) 対象のバッファ番号
-- @param findroot (string) 検索するディレクトリ
-- @return string|nil 見つかったファイルのフルパス、または見つからなければ nil
function find_formatter_config(filenames, bufnr, findroot)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    local start_dir

    if findroot then
        -- findrootが渡されているならばそれを開始点とする
        start_dir = findroot
    elseif buf_path and buf_path ~= "" then
        -- 開いているバッファのパスを開始点とする
        start_dir = vim.fn.fnamemodify(buf_path, ":h")
    else
        -- バッファが無ければcwdを開始点とする（nvimを引数なしで起動した場合）
        start_dir = vim.fn.getcwd()
    end

    if not start_dir then
        return nil
    end

    local project_root_dir = get_project_root(bufnr)
    if not project_root_dir then
        local msg = "[find_formatter_config] Project root not found. Skipping search."
        vim.notify(msg, vim.log.levels.INFO)
        return nil
    end

    if type(filenames) == "string" then
        filenames = { filenames }
    end

    -- 親方向に向かって探索
    local found_files = vim.fs.find(filenames, {
        path = start_dir,
        upward = true,
        limit = 1,
        type = "file"
    })

    -- 見つかった場合
    if #found_files > 0 then
        local found_file_path = found_files[1]
        local root_prefix = project_root_dir .. "/"
        if string.sub(found_file_path, 1, #root_prefix) == root_prefix then
            -- プロジェクト内に存在する場合、見つかったファイルパスを返却して終了
            local msg = string.format("[find_formatter_config] Found '%s' within project '%s'", found_file_path, project_root_dir)
            vim.notify(msg)
            return found_file_path
        else
            -- プロジェクトルート外で見つかった場合、nil返して終了
            local msg = string.format("[find_formatter_config] Found '%s' but it is outside project root '%s'. Ignored.", found_file_path, project_root_dir)
            vim.notify(msg)
            return nil
        end
    else
        -- プロジェクトルートまで遡っても見つからなかった場合、nil返して終了
        local msg = string.format("[find_formatter_config] '%s' is not found.", filenames)
        vim.notify(msg)
        return nil
    end
end

return find_formatter_config
