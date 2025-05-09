return {
  "amitds1997/remote-nvim.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  priority = 1000, -- Give this a high priority to ensure it loads early
  lazy = false, -- Don't lazy load
  config = function()
    require("remote-nvim").setup()
  end,
}
