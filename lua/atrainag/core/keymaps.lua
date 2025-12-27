vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save File" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>ll", ":Lazy<CR>")

-- Increment/decrement numbers
keymap.set("n", "+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts, { desc = "Save file" })
keymap.set("n", "<Leader>q", ":quit<Return>", opts, { desc = "Quit file" })
keymap.set("n", "<Leader>Q", ":qa!<Return>", opts, { desc = "Force Quit all files" })

-- Window management
keymap.set("n", "sv", "<C-w>v", { desc = "Split window vertically" })                          -- split window vertically
keymap.set("n", "sh", "<C-w>s", { desc = "Split window horizontally" })                        -- split window horizontally
keymap.set("n", "se", "<C-w>=", { desc = "Make splits equal size" })                           -- make split windows equal width & height
keymap.set("n", "sx", "<cmd>close<CR>", { desc = "Close current split" })                      -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                    -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })             -- close current tab
keymap.set("n", "<tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" })                         --  go to next tab
keymap.set("n", "<S-tab>", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                   --  go to previous tab
keymap.set("n", "<leader>te", "<cmd>tabedit<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal" }, { noremap = true, expr = true })
keymap.set("n", "<leader>tm", ":term<CR>", { desc = "Open terminal in current tab" })

-- Aliases
keymap.set("v", "ir", "i[", { desc = "Inside []" })
keymap.set("v", "ar", "a[", { desc = "Around []" })
keymap.set("v", "ia", "i<", { desc = "Inside <>" })
keymap.set("v", "aa", "a<", { desc = "Around <>" })

keymap.set("o", "ir", "i[", { desc = "Inside []" })
keymap.set("o", "ar", "a[", { desc = "Around []" })
keymap.set("o", "ia", "i<", { desc = "Inside <>" })
keymap.set("o", "aa", "a<", { desc = "Around <>" })

-- Utilities
function _G.check_visual_mode_append()
    if vim.fn.mode() == "V" then
        return "<C-v>g_A"
    else
        return "A"
    end
end

keymap.set("x", "<S-A>", "v:lua.check_visual_mode_append()", { noremap = true, expr = true })

function _G.check_visual_mode_insert()
    if vim.fn.mode() == "V" then
        return "<C-v>^I"
    else
        return "I"
    end
end

keymap.set("x", "<S-I>", "v:lua.check_visual_mode_insert()", { noremap = true, expr = true })

function SnakeToCamel()
    -- Get the current selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row, start_col = start_pos[2], start_pos[3]
    local end_row, end_col = end_pos[2], end_pos[3]

    -- Get all lines in the selected range
    local lines = vim.fn.getline(start_row, end_row)

    -- Handle single-line selection only
    if #lines > 1 then
        print("This function currently supports single-line selections.")
        return
    end

    -- Extract the selected text
    local line = lines[1]
    -- Adjust end_col to not exceed the line length
    end_col = math.min(end_col, #line)
    local text = line:sub(start_col, end_col)

    -- Perform snake_case to CamelCase transformation
    local camel_case = text
        :gsub("_(%w)", function(c)
            return c:upper()
        end)
        :gsub("^%l", string.upper)

    -- Replace the selected text
    vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, start_row - 1, end_col, { camel_case })
end

vim.api.nvim_set_keymap("v", "<leader>snc", ":lua SnakeToCamel()<CR>", { noremap = true, silent = true })

function CamelToSnake()
    -- Get the current selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row, start_col = start_pos[2], start_pos[3]
    local end_row, end_col = end_pos[2], end_pos[3]

    -- Get all lines in the selected range
    local lines = vim.fn.getline(start_row, end_row)

    -- Handle single-line selection only
    if #lines > 1 then
        print("This function currently supports single-line selections.")
        return
    end

    -- Extract the selected text
    local line = lines[1]
    -- Adjust end_col to not exceed the line length
    end_col = math.min(end_col, #line)
    local text = line:sub(start_col, end_col)

    -- Perform CamelCase to snake_case transformation
    local snake_case = text
        :gsub("(%u)(%u%l)", "%1_%2") -- Add underscore between consecutive uppercase and uppercase-lowercase
        :gsub("(%l)(%u)", "%1_%2")   -- Add underscore between lowercase and uppercase
        :lower()                     -- Convert all to lowercase

    -- Replace the selected text
    vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, start_row - 1, end_col, { snake_case })
end

vim.api.nvim_set_keymap("v", "<leader>cms", ":lua CamelToSnake()<CR>", { noremap = true, silent = true })
