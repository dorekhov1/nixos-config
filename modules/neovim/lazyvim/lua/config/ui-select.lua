vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    -- Force Snacks to be the UI select handler
    if require("snacks.picker") then
      vim.ui.select = require("snacks.picker").select
    end
  end,
})
