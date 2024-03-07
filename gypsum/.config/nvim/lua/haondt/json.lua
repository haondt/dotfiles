local M = {}

M.encode = function()
    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))

    if start_line == end_line and start_col == end_col then
        vim.cmd("echohl ErrorMsg | echom 'No text selected' | echohl None")
        return
    end

    local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local is_line_select = end_col >= 2^32/2-1
    if not is_line_select then
        local last_line_len = #selected_lines[#selected_lines]
        end_col = end_col < last_line_len - 1 and end_col or last_line_len - 1
    end


    if  not is_line_select then
        local end_slice = end_col - #selected_lines[#selected_lines]
        selected_lines[1] =  string.sub(selected_lines[1], start_col + 1)
        selected_lines[#selected_lines] = string.sub(selected_lines[#selected_lines], 1, end_slice)
    end

    local selected_text = table.concat(selected_lines, "\n")
    local json_stringified = vim.fn.json_encode(selected_text)

    if end_col >= 2^32/2-1 then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {json_stringified})
    else
        vim.api.nvim_buf_set_text(0, start_line - 1, start_col, end_line - 1, end_col + 1, {json_stringified})
    end

    print("JSON encoded")
end

M.decode = function()
    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))

    if start_line == end_line and start_col == end_col then
        vim.cmd("echohl ErrorMsg | echom 'No text selected' | echohl None")
        return
    end

    local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local is_line_select = end_col >= 2^32/2-1
    if not is_line_select then
        local last_line_len = #selected_lines[#selected_lines]
        end_col = end_col < last_line_len - 1 and end_col or last_line_len - 1
    end


    if  not is_line_select then
        local end_slice = end_col - #selected_lines[#selected_lines]
        selected_lines[1] =  string.sub(selected_lines[1], start_col + 1)
        selected_lines[#selected_lines] = string.sub(selected_lines[#selected_lines], 1, end_slice)
    end

    local selected_text = table.concat(selected_lines, "\n")
    local json_stringified = vim.fn.json_decode(selected_text)

    if end_col >= 2^32/2-1 then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {json_stringified})
    else
        vim.api.nvim_buf_set_text(0, start_line - 1, start_col, end_line - 1, end_col + 1, {json_stringified})
    end

    print("JSON decoded")
end



return M
