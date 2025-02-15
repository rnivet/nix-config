return {
  "folke/lazydev.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lazydev").setup()
  end
}
