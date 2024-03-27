return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = true,
        never_show = {
          ".git",
          ".direnv",
          ".mypy_cache",
          ".pyre",
          ".ruff_cache",
          ".devenv",
          ".venv",
          "result",
          ".devenv.flake.nix",
          ".pre-commit-config.yaml",
        },
        never_show_by_pattern = {
          "**/__pycache__",
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.cmd([[setlocal relativenumber]])
        end,
      },
    },
  },
}
