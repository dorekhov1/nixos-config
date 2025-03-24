return {
  -- Use folke's fork of snacks.nvim instead of LunarVim's
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      -- You can customize the options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },

}
