-- Better integration of dotnet in neovim
return {
  "GustavEikaas/easy-dotnet.nvim",
  commit = "f5ee1d9e13f485e032edee89c363474d20234e77",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
  config = function()
    require("easy-dotnet").setup()
  end
}
