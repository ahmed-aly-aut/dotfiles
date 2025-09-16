require("oil").setup({
    default_file_explorer = true,
    view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        --         is_hidden_file = function(name, bufnr)
        --             return false
        --         end,
    }
})
