return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "pyrightconfig.json",
        },
        ".git",
    },
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                autoImportCompletions = false,
                autoSeachPaths = false,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                diagnosticSeverityOverrides = {
                    reportPrivateImportUsage = "none",
                },
            },
        },
    },
}
