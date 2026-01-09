-- Code highlight plugin
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  dev = true,
  config = function()
    -- Modern nvim-treesitter no longer requires nvim-treesitter.configs
    -- Highlighting and indent are now built into Neovim's treesitter
    -- Parsers are provided via Nix and added to runtimepath in default.nix

    -- Enable treesitter highlighting (built-in to Neovim)
    vim.treesitter.language.register('yaml', 'yaml')
  end
}
