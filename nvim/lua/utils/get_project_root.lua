-- プロジェクトルートを取得（親方向に向かって .git または package.json を探す）
local function get_project_root(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    local start_dir

    if buf_path and buf_path ~= "" then
        -- 開いているバッファのパスを開始点とする
        start_dir = vim.fn.fnamemodify(buf_path, ":h")
    else
        -- バッファが無ければcwdを開始点とする（nvimを引数なしで起動した場合）
        start_dir = vim.fn.getcwd()
    end

    if not start_dir then
        return nil
    end

    local root_markers = { ".git", "package.json" }

    -- 開始ディレクトリから親ディレクトリに向かってマーカーを検索
    local found_markers = vim.fs.find(root_markers, {
        path = start_dir,
        upward = true,
        limit = 1
    })

    if #found_markers > 0 then
        -- マーカーが見つかった場合
        local marker_path = found_markers[1]
        local root_dir = vim.fn.fnamemodify(marker_path, ":h")
        return root_dir
    else
        -- マーカーが見つからなかった場合
        return nil
    end
end

return get_project_root
