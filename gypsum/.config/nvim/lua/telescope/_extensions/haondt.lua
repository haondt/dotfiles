local haondt =  require("haondt-telescope")
return require("telescope").register_extension {
    setup = function(ext_config, config)
    end,
    exports = {
        pickers = haondt.pickers,
        sorters = haondt.sorters
    }
}
