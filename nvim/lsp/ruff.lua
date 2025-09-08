return {
    cmd = { "ruff", "server", "--preview" },
    filetypes = { "python" },
    root_markers = {
        {
            "ruff.toml",
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
        },
        ".git",
    },
    init_options = {
        settings = {
            configurationPreference = 'filesystemFirst',
            fixAll = true,
            organizeImports = true,
            lint = {
                enable = true,
                preview = true,
            },
            format = {
                preview = true,
            },
        },
    },

}
