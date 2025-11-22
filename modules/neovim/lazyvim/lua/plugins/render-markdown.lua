return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons", -- Ensure we have the icons dependency
  },
  opts = {
    -- Use only direct options supported by the plugin - no nesting
    enabled = true,
    file_types = { "markdown", "Avante" },
    latex = {
      enabled = true, -- It's actually working correctly now
      converter = "latex2text",
    },
    html = {
      enabled = true,
    },
  },
  ft = { "markdown", "Avante" },
}
