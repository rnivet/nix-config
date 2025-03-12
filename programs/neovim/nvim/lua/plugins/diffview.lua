-- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup()
  end
}
