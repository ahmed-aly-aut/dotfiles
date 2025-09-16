function ColorMyPencils(color)
    color = color or "catppuccin-mocha"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

require("catppuccin").setup {
    transparent_background = true,
    flaovour = "mocha",
    custom_highlights = function(colors)
        return {
            -- Set the background of the active status line
            --StatusLine = { bg = colors.surface0, fg = colors.text },

            -- Set the background of inactive status lines
            StatusLineNC = { bg = colors.crust, fg = colors.surface2 },
        }
    end,
}
