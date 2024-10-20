-- A framework for interacting with tests within NeoVim.
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-python"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-python"),
      }
    })
    vim.keymap.set("n", "to", "<cmd>Neotest output<CR>",
      { desc = "Show tests output", noremap = true, silent = true })
    vim.keymap.set("n", "tr", "<cmd>Neotest run<CR>",
      { desc = "Run tests", noremap = true, silent = true })
  end
}
