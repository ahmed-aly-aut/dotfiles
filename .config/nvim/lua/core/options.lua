vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- adds line numbers
vim.o.number = true
-- enables realtive line numbers
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true

vim.o.swapfile = false

-- Save undo history
vim.o.undofile = true

vim.o.winborder = "rounded"

--vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.updatetime = 50

-- Enable break indent
vim.o.breakindent = true

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Show which line your cursor is on
vim.o.cursorline = true
