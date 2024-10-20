-- A file browser in nvim
return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      keymaps = {
        ["s"] = "actions.select_vsplit",
        ["q"] = "actions.close",
      },
      float = {
        padding = 5,
        max_width = 50,
      },
    })
    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
  end
}
