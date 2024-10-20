-- Show lsp progress in status line
return {
  "linrongbin16/lsp-progress.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lsp-progress").setup({})
  end
}
