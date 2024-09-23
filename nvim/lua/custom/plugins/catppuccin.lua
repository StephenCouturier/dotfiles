return {
    "catppuccin/nvim",
    as = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin'
      vim.api.nvim_set_hl(0, "Normal", { guibg = NONE, ctermbg = NONE })
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
    opts = {
      transparent_background = true
    }
  }
