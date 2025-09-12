local api, lsp = vim.api, vim.lsp
local diagnostic, keyset, autocmd = vim.diagnostic, vim.keymap.set, api.nvim_create_autocmd

local icons = require("core.icons")

-- Set up custom diagnostic signs for a better visual experience.
diagnostic.config({
    signs = {
        text = {
            [diagnostic.severity.ERROR] = icons.error,
            [diagnostic.severity.WARN] = icons.warn,
            [diagnostic.severity.INFO] = icons.info,
            [diagnostic.severity.HINT] = icons.hint,
        },
        texthl = {
            [diagnostic.severity.ERROR] = "Error",
            [diagnostic.severity.WARN] = "Error",
            [diagnostic.severity.HINT] = "Hint",
            [diagnostic.severity.INFO] = "Info",
        },
        numhl = {
            [diagnostic.severity.ERROR] = "",
            [diagnostic.severity.WARN] = "",
            [diagnostic.severity.HINT] = "",
            [diagnostic.severity.INFO] = "",
        },
    },
    virtual_text = true, -- Show diagnostics inline
    update_in_insert = true,
    underline = true,
    severity_sort = true,
})

autocmd("LspAttach", {
    group = api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local client = assert(lsp.get_client_by_id(args.data.client_id))

        -- Enable native autocompletion.
        if client:supports_method("textDocument/completion") then
            lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        -- Set omnifunc for fallback completion with Ctrl-X Ctrl-O
        api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")


        -- Core LSP Actions
        keyset('n', 'K', lsp.buf.hover, { buffer = bufnr, desc = 'LSP: Hover' })
        keyset('n', 'gd', lsp.buf.definition, { buffer = bufnr, desc = 'LSP: Go to Definition' })
        keyset('n', 'gD', lsp.buf.declaration, { buffer = bufnr, desc = 'LSP: Go to Declaration' })
        keyset('n', 'gr', lsp.buf.references, { buffer = bufnr, desc = 'LSP: Find References' })
        keyset('n', 'gi', lsp.buf.implementation, { buffer = bufnr, desc = 'LSP: Go to Implementation' })
        keyset('n', 'gt', lsp.buf.type_definition, { buffer = bufnr, desc = 'LSP: Go to Type Definition' })
        keyset('n', '<leader>ws', lsp.buf.workspace_symbol, { buffer = bufnr, desc = 'LSP: Workspace Symbols' })
        keyset('n', '<leader>ds', lsp.buf.document_symbol, { buffer = bufnr, desc = 'LSP: Document Symbols' })
        keyset('n', '<leader>sh', lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP: Signature Help' })


        -- Renaming and Code Actions
        keyset('n', '<leader>rn', lsp.buf.rename, { buffer = bufnr, desc = 'LSP: Rename' })
        keyset({ 'n', 'v' }, '<leader>ca', lsp.buf.code_action, { buffer = bufnr, desc = 'LSP: Code Action' })

        -- Diagnostic navigation
        keyset('n', '<leader>dn', diagnostic.goto_next, { buffer = bufnr, desc = 'Diagnostic: Next' })
        keyset('n', '<leader>dp', diagnostic.goto_prev, { buffer = bufnr, desc = 'Diagnostic: Previous' })
        keyset('n', '<leader>de', diagnostic.open_float, { buffer = bufnr, desc = 'Diagnostic: Show Line Diagnostics' })

        -- Enable LSP-based folding
        if client:supports_method("textDocument/foldingRange") then
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.lsp.util.make_fold_expr()"
            vim.opt_local.foldenable = true
            keyset('n', 'za', vim.cmd.foldopen, { buffer = bufnr, desc = "Fold: Toggle" })
        end

        -- Enable semantic tokens if the server supports it
        if client:supports_method("textDocument/semanticTokens/full") then
            vim.lsp.semantic_tokens.start(bufnr, client.id)
        end
    end,
})

-- Auto-format on save
autocmd("BufWritePre", {
    group = api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
    pattern = { "*.py", "*.lua", "*.xml", "*.csv" }, -- Add any other filetypes you want to auto-format
    callback = function()
        lsp.buf.format({ async = true })
    end,
})

vim.cmd("set completeopt+=noselect")

local function set_filetype(pattern, filetype)
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = pattern,
        command = "set filetype=" .. filetype,
    })
end

-- Allow .yml files to be registerd as .yaml
set_filetype({ "docker-compose.yml" }, "yaml.docker-compose")
set_filetype({ "compose.yaml" }, "yaml.docker-compose")
set_filetype({ "compose.yml" }, "yaml.docker-compose")

-- Enable all your language servers using the modern API.
-- Neovim will automatically load the configuration from the `lsp/` directory.
lsp.enable({
    "ruff",
    --    "pyright",
    "lua_ls",
    "odools",
    --"jsonls",
    "ty",
    --"docker_language_server",
    --"marksman",
})
