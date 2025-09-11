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
        -- As you correctly pointed out, we get the client and bufnr from the 'args' table.
        local bufnr = args.buf
        local client = assert(lsp.get_client_by_id(args.data.client_id))

        -- Enable native autocompletion.
        if client:supports_method("textDocument/completion") then
            lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        -- Set omnifunc for fallback completion with Ctrl-X Ctrl-O
        api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Core LSP Actions
        vim.keymap.set('n', 'K', lsp.buf.hover, { desc = 'LSP: Hover' })
        vim.keymap.set('n', 'gd', lsp.buf.definition, { desc = 'LSP: Go to Definition' })
        vim.keymap.set('n', 'gD', lsp.buf.declaration, { desc = 'LSP: Go to Declaration' })
        vim.keymap.set('n', 'gr', lsp.buf.references, { desc = 'LSP: Find References' })
        vim.keymap.set('n', 'gi', lsp.buf.implementation, { desc = 'LSP: Go to Implementation' })
        vim.keymap.set('n', '<leader>ws', lsp.buf.workspace_symbol, { desc = 'LSP: Workspace Symbols' })

        -- Renaming and Code Actions
        vim.keymap.set('n', '<leader>rn', lsp.buf.rename, { desc = 'LSP: Rename' })
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', lsp.buf.code_action, { desc = 'LSP: Code Action' })

        -- Diagnostic navigation
        vim.keymap.set('n', '<leader>dn', diagnostic.goto_next, { desc = 'Diagnostic: Next' })
        vim.keymap.set('n', '<leader>dp', diagnostic.goto_prev, { desc = 'Diagnostic: Previous' })
        vim.keymap.set('n', '<leader>de', diagnostic.open_float, { desc = 'Diagnostic: Show Line Diagnostics' })
    end,
})

-- Auto-format on save
autocmd("BufWritePre", {
    group = api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
    pattern = { "*.py", "*.lua" }, -- Add any other filetypes you want to auto-format
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
    "jsonls",
    "ty",
    "docker_language_server",
    "marksman",
})
