return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons", -- Ensure we have the icons dependency
  },
  opts = {
    -- Use the correct structure based on your version (8.1.8)
    file_types = { "markdown", "Avante" },

    -- Make sure to use the correct config structure
    -- The errors are because you have a newer version with different config keys
    theme = "catppuccin-mocha",

    -- Individual features
    latex = {
      enabled = true,
    },

    html = {
      enabled = true,
    },
  },
  ft = { "markdown", "Avante" },
  config = function(_, opts)
    -- Check the version to decide how to set up
    local _, render_markdown = pcall(require, "render-markdown")
    if render_markdown then
      render_markdown.setup(opts)
    end
  end,
}
