-- Renders markdown in-buffer: tables get real borders and aligned columns
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ft = { "markdown" },
  opts = {
    pipe_table = {
      preset = "round",   -- rounded corners; 'heavy'/'double'/'none' also available
      -- autocmds.lua turns wrap on for markdown; trimming keeps tables narrow
      -- so fewer rows fold mid-line
      cell = "trimmed",
    },
  },
}
