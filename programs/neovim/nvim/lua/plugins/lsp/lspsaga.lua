return {
  "nvimdev/lspsaga.nvim",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("lspsaga").setup({})

    vim.keymap.set("n", "<leader>t", "<cmd>Lspsaga term_toggle<CR>",
      { desc = "Show Terminal", noremap = true, silent = true })

    vim.diagnostic.config({
      severity_sort = true,
    })
  end
}
