local from_entry = require("telescope.from_entry")
local conf = require("telescope.config").values
local Path = require("plenary.path")

local buffer_previewer = require("telescope.previewers.buffer_previewer")

local ns_previewer = vim.api.nvim_create_namespace "haondt-telescope.previewers"
local previewers = {}

-- copied from buffer_previewer
local function defaulter(f, default_opts)
    default_opts = default_opts or {}
    return {
        new = function(opts)
            if conf.preview == false and not opts.preview then
                return false
            end
            opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
            if type(conf.preview) == "table" then
                for k, v in pairs(conf.preview) do
                    opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
                end
            end
            return f(opts)
        end,
        __call = function()
            local ok, err = pcall(f(default_opts))
            if not ok then
                error(debug.traceback(err))
            end
        end,
    }
end

-- slightly modified
previewers.vimgrep = defaulter(function(opts)
    opts = opts or {}
    local cwd = opts.cwd or vim.loop.cwd()

    local jump_to_line = function(self, bufnr, entry)
        pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_previewer, 0, -1)

        if entry.lnum and entry.lnum > 0 then
            local lnum, lnend = entry.lnum - 1, (entry.lnend or entry.lnum) - 1

            local col, colend = 0, -1
            -- Both col delimiters should be provided for them to take effect.
            -- This is to ensure that column range highlighting was opted in, as `col`
            -- is already used to determine the buffer jump position elsewhere.
            if entry.col and entry.colend then
                col, colend = entry.col - 1, entry.colend - 1
            end

            for i = lnum, lnend do
                pcall(
                vim.api.nvim_buf_add_highlight,
                bufnr,
                ns_previewer,
                "TelescopePreviewLine",
                i,
                i == lnum and col or 0,
                i == lnend and colend or -1
                )
            end

            local middle_ln = math.floor(lnum + (lnend - lnum) / 2)
            pcall(vim.api.nvim_win_set_cursor, self.state.winid, { middle_ln + 1, 0 })
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd "norm! zz"
            end)
        end
    end

    local set_filetype = function(bufnr)
        if opts.syntax == nil then
            return
        end
        vim.schedule(function ()
            local syntax = vim.api.nvim_buf_get_option(bufnr, 'syntax')
            if syntax ~= opts.syntax then
                vim.api.nvim_buf_set_option(bufnr, 'syntax', opts.syntax)
            end
        end)
    end

    return buffer_previewer.new_buffer_previewer {
        title = opts.previewer_title or "Grep Preview",
        dyn_title = opts.previewer_dyn_title or function(_, entry)
            return Path:new(from_entry.path(entry, false, false)):normalize(cwd)
        end,

        get_buffer_by_name = function(_, entry)
            return from_entry.path(entry, false)
        end,

        define_preview = function(self, entry, status)
            -- builtin.buffers: bypass path validation for terminal buffers that don't have appropriate path
            local has_buftype = entry.bufnr and vim.api.nvim_buf_get_option(entry.bufnr, "buftype") ~= "" or false
            local p
            if not has_buftype then
                p = from_entry.path(entry, true)
                if p == nil or p == "" then
                    return
                end
            end

            -- Workaround for unnamed buffer when using builtin.buffer
            if entry.bufnr and (p == "[No Name]" or has_buftype) then
                local lines = vim.api.nvim_buf_get_lines(entry.bufnr, 0, -1, false)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                set_filetype(self.state.bufnr)
                jump_to_line(self, self.state.bufnr, entry)
            else
                conf.buffer_previewer_maker(p, self.state.bufnr, {
                    bufname = self.state.bufname,
                    winid = self.state.winid,
                    preview = opts.preview,
                    callback = function(bufnr)
                        set_filetype(bufnr)
                        jump_to_line(self, bufnr, entry)
                    end,
                    file_encoding = opts.file_encoding,
                })
            end
        end,
    }
end, {})


return previewers
