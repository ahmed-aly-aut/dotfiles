return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        {
            ".luacheckrc",
            ".luarc.json",
            ".luarc.jsonc",
            ".stylua.toml",
            "selene.yml",
            "selene.yml",
            "stylua.toml",
        },
        ".git",
    },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = {
                    "vim",
                    "require",
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = true,
                },
            },
        }
    },
}
