-- Manage the buffer tab bar at the top of the window
return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
  },
  --  version = '^1.0.0',   -- optional: only update when a new 1.x version is released
  config = function()
    require("barbar").setup({
      -- Enables / disables diagnostic symbols
      icons = {
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
      },
    })
    vim.keymap.set("n", "<A-,>", "<cmd>BufferPrevious<CR>",
      { desc = "Go to previous buffer", noremap = true, silent = true })
    vim.keymap.set("n", "<A-;>", "<cmd>BufferNext<CR>",
      { desc = "Go to next buffer", noremap = true, silent = true })
    vim.keymap.set("n", "<A-c>", "<cmd>BufferClose<CR>",
      { desc = "Close buffer", noremap = true, silent = true })
  end
}
