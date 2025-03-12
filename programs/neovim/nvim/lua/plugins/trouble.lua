return {
  "folke/trouble.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("trouble").setup({
      win = {
        position = "right",
        size = 80,
      },
      modes = {
        mydiags = {
          mode = "diagnostics",
          auto_open = false,
          auto_close = true,
          focus = true,
          filter = {
            severity = vim.diagnostic.severity.ERROR, -- errors only
            -- any = {
            --   buf = 0,                                    -- current buffer
            --   {
            --     severity = vim.diagnostic.severity.ERROR, -- errors only
            --     -- limit to files in the current project
            --     function(item)
            --       return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
            --     end,
            --   },
            -- },
          }
        }
      }
    })
    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",
      { desc = "Show workspace diagnostics", noremap = true, silent = true })
  end
}
