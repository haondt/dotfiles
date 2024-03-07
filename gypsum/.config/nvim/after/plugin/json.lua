local json = require("haondt.json")

vim.api.nvim_create_user_command('JsonEncode', json.encode, {
    range = true
})

vim.api.nvim_create_user_command('JsonDecode', json.decode, {
    range = true
})
