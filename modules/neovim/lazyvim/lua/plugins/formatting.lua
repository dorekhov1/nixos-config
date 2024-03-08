return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      ["fish"] = {}, -- replace default
      ["python"] = { "ruff_fix", "ruff_format" },
    },
  },
}
