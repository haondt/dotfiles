local M = {}

local conflict_markers = {
    START = '<<<<<<<',
    COMMON = '|||||||',
    REMOTE = '=======',
    END = '>>>>>>>',
}

local get_block_range = function()
    local _try_get_block = function()
        local cursor_pos = vim.fn.getpos('.')
        local cursor_line = cursor_pos[2]
        vim.fn.cursor(cursor_line,1)
        local block_start = vim.fn.search('^' .. conflict_markers.START, 'bncW')
        if block_start == 0 then
            return nil
        end
        local block_end = vim.fn.search('^' .. conflict_markers.END, 'nceW')
        if block_end == 0 then
            return nil
        end
        return { block_start, block_end }
    end
    vim.cmd([[normal! m']])
    local coords = _try_get_block()
    vim.cmd([[normal! `']])
    return coords
end

local validate_block = function(lines)
    local output = {}
    if lines[1] and lines[1]:find('^' .. conflict_markers.START) then
        output.START = 1
    else
        output.ERROR = "Unable to find conflict start"
        return false, output
    end

    if lines[#lines] and lines[#lines]:find('^' .. conflict_markers.END) then
        output.END = #lines
    else
        output.ERROR = "Unable to find conflict end"
        return false, output
    end

    local foundCommon = false
    local foundRemote = false

    for i = 2, #lines - 1 do
        if lines[i]:find('^' .. conflict_markers.START) then
            output.ERROR = "Found multiple start markers in conflict"
            return false, output
        end
        if lines[i]:find('^' .. conflict_markers.END) then
            output.ERROR = "Found multiple end markers in conflict"
            return false, output
        end
        if lines[i]:find('^' .. conflict_markers.REMOTE) then
            if foundRemote then
                output.ERROR = "Found multiple remote markers in conflict"
                return false, output
            end

            foundRemote = true
            output.REMOTE = i
        elseif lines[i]:find('^' .. conflict_markers.COMMON) then
            if foundRemote then
                output.ERROR = "Found common ancestor marker after remote marker in conflict"
                return false, output
            elseif foundCommon then
                output.ERROR = "Found multiple common ancestor markers in conflict"
                return false, output
            end
            foundCommon = true
            output.COMMON = i
        end
    end

    if not foundRemote then
        output.ERROR = "Unable to find remote marker in conflict"
        return false, output
    end

    return true, output
end


M.take_local = function()
    local coords = get_block_range()
    if coords == nil then
        print("Not inside a merge conflict")
        return
    end
    local lines = vim.fn.getline(coords[1], coords[2])

    local valid, relative_markers = validate_block(lines)
    if not valid then
        print(relative_markers.ERROR)
        return
    end

    vim.fn.cursor(coords[1] + relative_markers.START - 1,1)
    vim.cmd('normal! ' .. #lines .. 'D')
    local new_lines = { unpack(lines, relative_markers.START + 1, (relative_markers.COMMON or relative_markers.REMOTE) - 1) }
    vim.fn.append(coords[1] - 1, new_lines)
    vim.fn.cursor(coords[1], 1)

    print("Took local")
end

M.take_remote = function()
    local coords = get_block_range()
    if coords == nil then
        print("Not inside a merge conflict")
        return
    end
    local lines = vim.fn.getline(coords[1], coords[2])

    local valid, relative_markers = validate_block(lines)
    if not valid then
        print(relative_markers.ERROR)
        return
    end

    vim.fn.cursor(coords[1] + relative_markers.START - 1,1)
    vim.cmd('normal! ' .. #lines .. 'D')
    local new_lines = { unpack(lines, relative_markers.REMOTE + 1, relative_markers.END - 1) }
    vim.fn.append(coords[1] - 1, new_lines)
    vim.fn.cursor(coords[1], 1)

    print("Took remote")
end

M.take_local_and_remote = function()
    local coords = get_block_range()
    if coords == nil then
        print("Not inside a merge conflict")
        return
    end
    local lines = vim.fn.getline(coords[1], coords[2])

    local valid, relative_markers = validate_block(lines)
    if not valid then
        print(relative_markers.ERROR)
        return
    end

    vim.fn.cursor(coords[1] + relative_markers.START - 1,1)
    vim.cmd('normal! ' .. #lines .. 'D')
    local local_lines = { unpack(lines, relative_markers.START + 1, (relative_markers.COMMON or relative_markers.REMOTE) - 1) }
    local remote_lines = { unpack(lines, relative_markers.REMOTE + 1, relative_markers.END - 1) }
    local new_lines = { unpack(local_lines) }
    table.move(remote_lines, 1, #remote_lines, #new_lines + 1, new_lines)
    vim.fn.append(coords[1] - 1, new_lines)
    vim.fn.cursor(coords[1], 1)

    print("Took local and remote")
end

M.remove_markers = function()
    local cursor_pos = vim.fn.getpos('.')
    local coords = get_block_range()
    if coords == nil then
        print("Not inside a merge conflict")
        return
    end
    local lines = vim.fn.getline(coords[1], coords[2])

    local valid, relative_markers = validate_block(lines)
    if not valid then
        print(relative_markers.ERROR)
        return
    end

    local moved = 2
    vim.fn.cursor(coords[1] + relative_markers.START - 1,1)
    vim.cmd('normal! dd')
    if relative_markers.COMMON ~= nil then
        vim.fn.cursor(coords[1] + relative_markers.COMMON - moved,1)
        vim.cmd('normal! dd')
        moved = moved + 1
    end
    vim.fn.cursor(coords[1] + relative_markers.REMOTE - moved,1)
    moved = moved + 1
    vim.cmd('normal! dd')
    vim.fn.cursor(coords[1] + relative_markers.END - moved,1)
    vim.cmd('normal! dd')
    moved = moved + 1

    vim.fn.setpos('.', cursor_pos)
    print("Removed conflict markers")
end

M.next_conflict = function()
    vim.fn.search('^' .. conflict_markers.START)
end

M.previous_conflict = function()
    vim.fn.search('^' .. conflict_markers.START, 'b')
end

return M
