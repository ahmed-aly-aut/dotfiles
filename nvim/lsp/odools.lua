-- lsp/odools.lua
return {
    cmd = { "odoo_ls_server" },
    filetypes = {
        "python",
        "xml",
        "csv",
    },

    -- This is a robust, manual version of root_dir that works on older Neovim versions.
    --root_dir = "/Users/Ahmed.Aly/repositories/odoo",
    root_dir = vim.fs.root(0, { "pyproject.toml", "odools.toml" }),
    root_markers = {
        {
            "pyproject.toml",
            "odools.toml",
        },
        ".git"
    },
    --    workspace_folders = { {
    --        uri = vim.uri_from_fname('/Users/Ahmed.Aly/repositories/odoo'),
    --        name = 'main_folder',
    --    } },
    settings = {
        Odoo = {
            selectedProfile = "main",
        }
    },
}
