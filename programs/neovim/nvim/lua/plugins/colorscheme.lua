-- Load nvim colorscheme plugin
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- load colorscheme here
    vim.cmd([[colorscheme tokyonight-moon]])
  end,
}
