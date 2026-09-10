-- Renders markdown in-buffer: tables get real borders and aligned columns
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ft = { "markdown" },
  opts = {
    pipe_table = {
      preset = "round",   -- rounded corners; 'heavy'/'double'/'none' also available
      cell = "padded",    -- pad columns to equal visual width (the default)
    },
    win_options = {
      -- autocmds.lua turns wrap on for markdown, which folds wide tables
      -- mid-row. Off while rendered, back on in insert mode for prose.
      wrap = { default = true, rendered = false },
    },
  },
}
