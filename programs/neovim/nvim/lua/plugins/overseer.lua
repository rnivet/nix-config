-- A task runner and job management plugin for Neovim
return {
  'stevearc/overseer.nvim',
  config = function()
    require('overseer').setup()
  end
}
