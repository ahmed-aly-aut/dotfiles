-- lsp/odools.lua

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.hover.contentFormat = { "markdown", "plaintext" }

capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
    cmd = { "odoo_ls_server" },
    filetypes = {
        "python",
        "xml",
        "csv",
    },
    root_markers = {
        {
            "pyproject.toml",
            "odools.toml",
        },
        ".git",
    },
    capabilities = capabilities,
    settings = {
        Odoo = {
            selectedProfile = "main",
        },
    },
}
