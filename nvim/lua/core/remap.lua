#vim.keymap.set("n", "<leader>pv", ":Ex<CR>")
vim.keymap.set("n", "<leader>pv", ":Oil<CR>")

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format file" })

vim.keymap.set({ "n", "v", "x" }, "<leader>y", "\"+y<CR>", { desc = "yank to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>w", "\"+d<CR>", { desc = "cut to clipboard" })

-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
vim.keymap.set("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
vim.keymap.set("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
vim.keymap.set("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move selected lines with shift+j or shift+k
vim.keymap.set("v", "J", ":m \">+1<CR>gv=gv", { desc = "Move selected lines below with indenting" })
vim.keymap.set("v", "K", ":m \"<-2<CR>gv=gv", { desc = "Move selected lines above with indenting" })

vim.keymap.set("n", "<Leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
    { desc = "Search and replace word under the cursor" })

vim.keymap.set("n", "<leader>m", ":Mason<CR>", { desc = "Open [M]ason package manager" })
vim.keymap.set("n", "<leader>ll", ":Lazy<CR>", { desc = "Open [L]azy plugin manager" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic [Q]uickfix list" })

-- Search and replace word under the cursor
vim.keymap.set("n", "<Leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
    { desc = "Search and replace word under the cursor" })
