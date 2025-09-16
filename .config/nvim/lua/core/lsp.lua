local api, lsp = vim.api, vim.lsp
local diagnostic, keyset, autocmd = vim.diagnostic, vim.keymap.set, api.nvim_create_autocmd

local icons = require("core.icons")

local M = {}

function M.default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Announce that Neovim prefers UTF-8 for position encoding
    capabilities.general.positionEncodings = { "utf-16" }
    capabilities.offset_encoding = "utf-16"
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    return capabilities
end

lsp.config("*", {
    capabilities = M.default_capabilities(),
})

-- Diagnostic Config
-- Set up custom diagnostic signs for a better visual experience.
-- See :help vim.diagnostic.Opts
diagnostic.config({
    signs = vim.g.have_nerd_font and {
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
    } or {},
    virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(_diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = _diagnostic.message,
                [vim.diagnostic.severity.WARN] = _diagnostic.message,
                [vim.diagnostic.severity.INFO] = _diagnostic.message,
                [vim.diagnostic.severity.HINT] = _diagnostic.message,
            }
            return diagnostic_message[_diagnostic.severity]
        end,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
})

autocmd("LspAttach", {
    group = api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local client = assert(lsp.get_client_by_id(args.data.client_id))

        local function map(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end

        -- Enable native autocompletion.
        if client_supports_method(client, "textDocument/completion", bufnr) then
            -- trigger autocompletion in EVERY keypress.
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars

            lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            -- Auto-format on save
            autocmd("BufWritePre", {
                group = api.nvim_create_augroup("LspFormatOnSave", { clear = false }),
                buffer = bufnr,
                callback = function()
                    lsp.buf.format({ bufnr = bufnr, id = client.id, async = true })
                end,
            })
        end

        -- Set omnifunc for fallback completion with Ctrl-X Ctrl-O
        api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
            local highlight_augroup = vim.api.nvim_create_augroup('UserLspHighlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('UserLspDetach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'UserLspHighlight', buffer = event2.buf }
                end,
            })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- Find references for the word under your cursor.
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')


        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
            -- map('<leader>th', function()
            --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
            -- end, '[T]oggle Inlay [H]ints')
        end

        -- Core LSP Actions
        map('K', vim.lsp.buf.hover, "Hover")
        keyset('n', 'gd', lsp.buf.definition, { buffer = bufnr, desc = 'LSP: Go to Definition' })
        keyset('n', 'gD', lsp.buf.declaration, { buffer = bufnr, desc = 'LSP: Go to Declaration' })
        keyset('n', 'gr', lsp.buf.references, { buffer = bufnr, desc = 'LSP: Find References' })
        keyset('n', 'gi', lsp.buf.implementation, { buffer = bufnr, desc = 'LSP: Go to Implementation' })
        keyset('n', 'gt', lsp.buf.type_definition, { buffer = bufnr, desc = 'LSP: Go to Type Definition' })
        keyset('n', '<leader>ws', lsp.buf.workspace_symbol, { buffer = bufnr, desc = 'LSP: Workspace Symbols' })
        keyset('n', '<leader>ds', lsp.buf.document_symbol, { buffer = bufnr, desc = 'LSP: Document Symbols' })
        keyset('n', '<leader>sh', lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP: Signature Help' })

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
