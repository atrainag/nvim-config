require("atrainag.core")
require("atrainag.lazy")

-- Auto-read when a file is changed from the outside
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  callback = function()
    vim.cmd("checktime")
  end,
})
