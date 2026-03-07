local function is_zero_blob(blob)
    return blob ~= nil and blob:match("^0+$") ~= nil
end

local function write_blob_to_file(blob, path)
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

    if blob == nil or blob == "" or is_zero_blob(blob) then
        vim.fn.writefile({}, path)
        return true
    end

    local content = vim.fn.systemlist({ "git", "show", blob })
    if vim.v.shell_error ~= 0 then
        return false, table.concat(content, "\n")
    end

    vim.fn.writefile(content, path)
    return true
end

local function configure_temp_buffer()
    vim.bo.buflisted = false
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.bo.readonly = true
    vim.bo.modifiable = false
end

local function open_diff_tab(old_path, new_path)
    vim.cmd("tabnew")
    vim.cmd("edit " .. vim.fn.fnameescape(old_path))
    configure_temp_buffer()
    vim.cmd("vert diffsplit " .. vim.fn.fnameescape(new_path))
    configure_temp_buffer()
end

vim.api.nvim_create_user_command("Gitdiff", function(opts)
    local repo_root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
    if vim.v.shell_error ~= 0 or not repo_root[1] then
        vim.notify("[gitdiff] Error: Not a git repository.", vim.log.levels.ERROR)
        return
    end

    local args = opts.fargs or {}
    local diff_cmd = { "git", "diff", "--raw", "-M" }
    vim.list_extend(diff_cmd, args)

    local diff_output = vim.fn.systemlist(diff_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("[gitdiff] Error: git diff failed.", vim.log.levels.ERROR)
        return
    end

    if #diff_output == 0 then
        return
    end

    local tmp_dir = vim.fn.stdpath("cache") .. "/gitdiff"
    vim.fn.mkdir(tmp_dir, "p")

    for _, line in ipairs(diff_output) do
        local segments = vim.split(line, "\t", { plain = true })
        local meta_parts = vim.split(segments[1], "%s+", { trimempty = true })

        local status_full = meta_parts[#meta_parts] or ""
        local status_code = status_full:sub(1, 1)
        local old_blob = meta_parts[3]
        local new_blob = meta_parts[4]

        local old_path = segments[2]
        local new_path = segments[2]

        if (status_code == "R" or status_code == "C") and segments[3] then
            old_path = segments[2]
            new_path = segments[3]
        end

        if not old_path or not new_path then
            vim.notify("[gitdiff] Error: Failed to parse git diff output.", vim.log.levels.ERROR)
            return
        end

        local old_tmp = tmp_dir .. "/a/" .. old_path
        local new_tmp = tmp_dir .. "/b/" .. new_path

        local ok_old, err_old = write_blob_to_file(old_blob, old_tmp)
        if not ok_old then
            vim.notify("[gitdiff] Error: git show failed (old blob).\n" .. (err_old or ""), vim.log.levels.ERROR)
            return
        end

        local ok_new, err_new = write_blob_to_file(new_blob, new_tmp)
        if not ok_new then
            vim.notify("[gitdiff] Error: git show failed (new blob).\n" .. (err_new or ""), vim.log.levels.ERROR)
            return
        end

        open_diff_tab(old_tmp, new_tmp)
    end
end, { nargs = "*" })
