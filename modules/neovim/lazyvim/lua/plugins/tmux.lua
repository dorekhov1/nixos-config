return {
  {
    "aserowy/tmux.nvim",
    lazy = false,
    opts = {
      copy_sync = {
        enable = false,
        sync_clipboard = false,
        sync_registers = true,
      },
      resize = {
        enable_default_keybindings = false,
      },
    },
    keys = {
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
      },
    },
  },
}
