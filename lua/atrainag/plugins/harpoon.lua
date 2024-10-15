return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      vim.keymap.set("n", "<leader>am", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Open harpoon window" })
      vim.keymap.set("n", "<leader>aa", function()
        harpoon:list():add()
      end, { desc = "Add current file into harpoon" })

      vim.keymap.set("n", "<leader>a1", function()
        harpoon:list():select(1)
      end, { desc = "First harpoon window" })
      vim.keymap.set("n", "<leader>a2", function()
        harpoon:list():select(2)
      end, { desc = "Second harpoon window" })
      vim.keymap.set("n", "<leader>a3", function()
        harpoon:list():select(3)
      end, { desc = "Third harpoon window" })
      vim.keymap.set("n", "<leader>a4", function()
        harpoon:list():select(4)
      end, { desc = "Fourth harpoon window" })
    end,
  },
}
