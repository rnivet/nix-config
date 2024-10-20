-- Folding plugin
return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('ufo').setup()

    -- set keymaps
    -- Using ufo provider need remap `zR` and `zM`.
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  end
}
