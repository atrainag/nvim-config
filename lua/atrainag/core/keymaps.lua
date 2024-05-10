vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save File" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>ll", ":Lazy<CR>")
--
-- select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- increment/decrement numbers
keymap.set("n", "+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts, { desc = "Save file" })
keymap.set("n", "<Leader>q", ":quit<Return>", opts, { desc = "Quit file" })
keymap.set("n", "<Leader>Q", ":qa!<Return>", opts, { desc = "Force Quit all files" })

-- window management
keymap.set("n", "sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<S-tab>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>te", "<cmd>tabedit<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
