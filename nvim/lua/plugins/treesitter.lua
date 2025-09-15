return {
    {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
    {"nvim-treesitter/nvim-treesitter-context", after = "nvim-treesitter"},
}
