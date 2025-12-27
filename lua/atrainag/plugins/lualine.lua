return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        local colors = {
            blue = "#65D1FF",
            green = "#3EFFDC",
            violet = "#FF61EF",
            yellow = "#FFDA7B",
            red = "#FF4A4A",
            fg = "#c3ccdc",
            bg = "#112638",
            inactive_bg = "#2c3043",
        }

        local my_lualine_theme = {
            normal = {
                a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
                a = { bg = colors.green, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            visual = {
                a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            replace = {
                a = { bg = colors.red, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            inactive = {
                a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
                b = { bg = colors.inactive_bg, fg = colors.semilightgray },
                c = { bg = colors.inactive_bg, fg = colors.semilightgray },
            },
        }
        local function recording_status()
            local reg = vim.fn.reg_recording()
            if reg and reg ~= "" then
                return "Recording @" .. reg
            end
            return ""
        end

        local function smart_count()
            local wc = vim.fn.wordcount()
            local count = 0
            local is_visual = vim.fn.mode():find("[vV\22]")

            -- Check if the current line or selection contains Chinese characters
            local line = vim.api.nvim_get_current_line()
            local is_chinese = line:find("[\228-\233][\128-\191][\128-\191]")

            if is_chinese then
                count = is_visual and (wc.visual_chars or 0) or wc.chars
                return count .. " 字"
            else
                count = is_visual and (wc.visual_words or 0) or wc.words
                local label = count > 1 and "words" or "word"
                return count .. " " .. label
            end
        end

        local function get_wordcount()
            local word_count = 0

            if vim.fn.mode():find("[vV]") then
                word_count = vim.fn.wordcount().visual_words
            else
                word_count = vim.fn.wordcount().words
            end

            return word_count
        end

        -- local function wordcount()
        --     local label = "word"
        --     local word_count = get_wordcount()
        --
        --     if word_count > 1 then
        --         label = label .. "s"
        --     end
        --
        --     return word_count .. " " .. label
        -- end

        local function readingtime()
            -- 200 is about the average words read per minute.
            return tostring(math.ceil(get_wordcount() / 200.0)) .. " min"
        end

        local function is_prose()
            return vim.bo.filetype == "markdown" or vim.bo.filetype == "text"
        end
        -- configure lualine with modified theme
        lualine.setup({
            options = {
                theme = my_lualine_theme,
            },
            sections = {
                lualine_x = {
                    recording_status,
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
                lualine_z = {
                    { smart_count, cond = is_prose },
                    { readingtime, cond = is_prose },
                }
            },
        })
    end,
}
