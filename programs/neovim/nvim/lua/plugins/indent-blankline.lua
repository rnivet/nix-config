-- Show indent in margin plugin
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  config = function()
    require("ibl").setup(
      {
        indent = {
          tab_char = { "▎" },
        }
      }
    )
  end
}
