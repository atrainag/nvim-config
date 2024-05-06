return {
  --incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "incremental rename",
        mode = "n",
        noremap = true,
        expr = true,
      },
    },
    config = function()
      require("dressing").setup({
        input = {
          override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
          end,
        },
      })
      require("inc_rename").setup({
        input_buffer_type = "dressing",
      })
    end,
  },
  -- refactoring tool
  {
    "theprimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },
}
