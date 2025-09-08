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
                globals = { "vim" },
            },
        }
    },
}
