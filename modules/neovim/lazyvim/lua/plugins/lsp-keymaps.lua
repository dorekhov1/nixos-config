return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          {
            "gd",
            function()
              require("telescope.builtin").lsp_definitions({ reuse_win = true })
            end,
            desc = "Goto Definition",
            has = "definition",
          },
          {
            "gr",
            function()
              require("telescope.builtin").lsp_references()
            end,
            desc = "References",
          },
          {
            "gI",
            function()
              require("telescope.builtin").lsp_implementations({ reuse_win = true })
            end,
            desc = "Goto Implementation",
          },
          {
            "gy",
            function()
              require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
            end,
            desc = "Goto Type Definition",
          },
        },
      },
    },
  },
}
