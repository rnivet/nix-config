-- Show code context with treesitter-context
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("treesitter-context").setup({
      enable = true
    })
  end
}
