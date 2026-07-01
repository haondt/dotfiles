local M = {}

local config = {
    keys = {
        open_tab = { "<leader>1", "<leader>2", "<leader>3", "<leader>4", "<leader>5" },
        move_tab = { "<leader>!", "<leader>@", "<leader>#", "<leader>$", "<leader>%" },
    }
}

TabState = {
    tab_map = {},
}

local create_new_tab_buf = function()
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'delete')
    return buf
end

local function clean_tab_map()
    for id, nvim_tab in pairs(TabState.tab_map) do
        if not vim.api.nvim_tabpage_is_valid(nvim_tab) then
            TabState.tab_map[id] = nil
        end
    end
end

local function order_tab(internal_id, current_position)
    local desired = 1
    for id, _ in pairs(TabState.tab_map) do
        if id < internal_id then
            desired = desired + 1
        end
    end
    local delta = desired - current_position

    if delta == 0 then
        return
    elseif delta < 0 then
        vim.cmd("tabmove " .. delta)
    else
        vim.cmd("tabmove +" .. delta)
    end
end

function M.activate_tab(internal_id)
    clean_tab_map()
    local nvim_tab = TabState.tab_map[internal_id]
    if nvim_tab then
        vim.api.nvim_set_current_tabpage(nvim_tab)
    else
        nvim_tab = vim.api.nvim_open_tabpage(create_new_tab_buf(), true, {})
        order_tab(internal_id, vim.api.nvim_tabpage_get_number(nvim_tab))
        TabState.tab_map[internal_id] = nvim_tab
    end
end

function M.move_current_to_tab(internal_id)
    clean_tab_map()
    local current_win = vim.api.nvim_get_current_win()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local target_tab = TabState.tab_map[internal_id]

    -- Already on target tab: nothing to do
    if target_tab and current_tab == target_tab then
        return
    end

    -- If current window is the last one in its tab, create a temp window
    local wins_in_current_tab = vim.api.nvim_tabpage_list_wins(current_tab)
    local is_last_window = #wins_in_current_tab == 1
    if is_last_window then
        vim.cmd('vsplit')
    end

    if target_tab then
        -- Move current window to existing target tab and activate it
        local target_wins = vim.api.nvim_tabpage_list_wins(target_tab)
        vim.api.nvim_win_set_config(current_win, { win = target_wins[1], split = 'left' })
        vim.api.nvim_set_current_tabpage(target_tab)
    else
        -- Create new target tab and move current window there
        local temp_buf = create_new_tab_buf()
        target_tab = vim.api.nvim_open_tabpage(temp_buf, false, {})
        order_tab(internal_id, vim.api.nvim_tabpage_get_number(target_tab))
        TabState.tab_map[internal_id] = target_tab

        local target_wins = vim.api.nvim_tabpage_list_wins(target_tab)
        vim.api.nvim_win_set_config(current_win, { win = target_wins[1], split = 'left' })
        vim.api.nvim_buf_delete(temp_buf, {})
        vim.api.nvim_set_current_tabpage(target_tab)
    end

    -- Close temp window (and its tabpage if it was the last window)
    if is_last_window then
        vim.api.nvim_set_current_tabpage(current_tab)
        vim.cmd('close')
        vim.api.nvim_set_current_tabpage(target_tab)
    end
end

function M.render_tabline()
    local s = ""
    local current_tab = vim.api.nvim_get_current_tabpage()
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local is_active = tab == current_tab
        local hl = is_active and "TabLineSel" or "TabLine"

        local internal_id = nil
        for id, nvim_t in pairs(TabState.tab_map) do
            if nvim_t == tab then
                internal_id = id
                break
            end
        end

        local win = vim.api.nvim_tabpage_get_win(tab)
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
        if bufname == "" then bufname = "[No Name]" end

        s = s .. "%#" .. hl .. "# "
        if internal_id then
            s = s .. internal_id .. ":" .. bufname
            s = s .. (is_active and "*" or "-")
        else
            s = s .. bufname
        end
        s = s .. " "
    end
    s = s .. "%#TabLineFill#"
    return s
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    TabState.tab_map[1] = vim.api.nvim_get_current_tabpage()

    for i, key in ipairs(config.keys.open_tab) do
        vim.keymap.set("n", key, function()
            M.activate_tab(i)
        end, { noremap = true })
    end

    for i, key in ipairs(config.keys.move_tab) do
        vim.keymap.set("n", key, function()
            M.move_current_to_tab(i)
        end, { noremap = true })
    end
end

return M
