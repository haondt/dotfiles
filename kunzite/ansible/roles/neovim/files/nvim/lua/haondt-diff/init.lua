local Path = require("plenary.path")

local M = {}

--local logpath = Path:new("/home/noah/foo.txt")
local log = function (text)
    --logpath:write(text .. "\n", "a")
end

local clean_path = function(path)
    local cleaned_path = path
    local cleaner_path = path:gsub("/%./", "/")
    while cleaner_path ~= cleaned_path do
      cleaned_path = cleaner_path
      cleaner_path = cleaned_path:gsub("/%./", "/")
    end
    return cleaned_path
end

local make_path_absolute = function(base_path, path)
    base_path = Path:new(clean_path(base_path))
    path = Path:new(clean_path(path))
    if path:is_absolute() or #tostring(path) == 0 then
        return tostring(path)
    end
    local s=  clean_path(tostring(base_path:joinpath(path)))
        return s
end


local sync_windows = function(opts)

    local target_bufnr = opts.event.buf
    local target_windows = vim.fn.win_findbuf(target_bufnr)
    log(string.format("targeted windows: %s", vim.inspect(target_windows)))

    local local_file = nil
    local remote_file = nil

    if string.sub(opts.event.file, 1, #opts.local_dir) == opts.local_dir then
        local_file = opts.event.file
        remote_file = opts.remote_dir .. string.sub(local_file, #opts.local_dir + 1)
    elseif string.sub(opts.event.file, 1, #opts.remote_dir) == opts.remote_dir then
        remote_file = opts.event.file
        local_file = opts.local_dir .. string.sub(remote_file, #opts.remote_dir + 1)
    else
        return
    end

    log(string.format("syncing local file: %s and remote_file: %s", local_file, remote_file))

    local current_local_bufnr = vim.fn.winbufnr(opts.local_winid)
    local current_remote_bufnr = vim.fn.winbufnr(opts.remote_winid)
    local current_local_file = vim.api.nvim_buf_get_name(current_local_bufnr)
    local current_remote_file = vim.api.nvim_buf_get_name(current_remote_bufnr)

        vim.fn.win_gotoid(opts.local_winid)
        if current_local_file ~= local_file then
        vim.cmd('e ' .. local_file)
    end
    if current_remote_file ~= remote_file then
        vim.fn.win_gotoid(opts.remote_winid)
        vim.cmd('e ' .. remote_file)
    end


end

M.difftool = function()
    local local_dir = os.getenv('LOCAL')
    local remote_dir = os.getenv('REMOTE')
    local cwd = vim.loop.cwd()
    log(string.format("local dir: %s", local_dir))
    log(string.format("remote dir: %s", remote_dir))
    if local_dir == nil then
        error("DiffTool: $LOCAL not set")
    end
    if remote_dir == nil then
        error("DiffTool: $REMOTE not set")
    end

    local remote_winid = vim.fn.win_getid()
    log(string.format("remote winid: %d", remote_winid))

    local default_bufnr = vim.fn.bufnr('%')
    log(string.format('default bufnr: %d', default_bufnr))

    vim.cmd('vsplit')

    local local_winid = vim.fn.win_getid()
    log(string.format("local winid: %d", local_winid))


    local in_callback = false
    vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
        group = vim.api.nvim_create_augroup('haondt-diff-file-open', { clear = true }),
        callback = function(event)
            if in_callback then
                return
            end

            -- non-file buffers will still have the cwd in them, like minintro and NvimTree
            -- but file buffers might not exist on disk if they are unwritten (i.e. comparing an exsting and non-existing file)
            if string.sub(event.file, 1, #local_dir) == local_dir ~= true and
                string.sub(event.file, 1, #remote_dir) == remote_dir ~= true then
                return
            end

            in_callback = true
            log(string.format('event fired: %s', vim.inspect(event)))
            event.file = make_path_absolute(cwd, event.file)
            vim.schedule(function ()
                sync_windows({
                    event = event,
                    local_dir = local_dir,
                    remote_dir = remote_dir,
                    local_winid = local_winid,
                    remote_winid = remote_winid,
                    cwd = cwd
                })
                --print(string.format('event fired: %s', event.event))
                vim.cmd('windo diffthis')
                vim.cmd('windo set cursorline')
                in_callback = false
            end)
        end
    })

    vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
        group = vim.api.nvim_create_augroup('haondt-diff-buf-leave', { clear = true }),
        callback = function(event)
            event.file = make_path_absolute(cwd, event.file)

            if string.sub(event.file, 1, #cwd) ~= cwd then
                return
            end

            -- non-file buffers will still have the cwd in them, like minintro and NvimTree
            -- but file buffers might not exist on disk if they are unwritten (i.e. comparing an exsting and non-existing file)
            if string.sub(event.file, 1, #local_dir) == local_dir ~= true and
                string.sub(event.file, 1, #remote_dir) == remote_dir ~= true then
                return
            end

            log(string.format('event fired: %s', vim.inspect(event)))
            vim.cmd('windo diffoff')
        end
    })
end

return M
