return {
  "nvimdev/lspsaga.nvim",
  lazy = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("lspsaga").setup({})
    vim.keymap.set("n", "<leader>t", "<cmd>Lspsaga term_toggle<CR>",
      { desc = "Show Terminal", noremap = true, silent = true })
  end
}
