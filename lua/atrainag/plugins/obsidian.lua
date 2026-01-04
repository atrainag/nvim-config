return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local workspaces
    local uname = vim.loop.os_uname().sysname
    local is_windows = uname == "Windows_NT"
    local is_macos = uname == "Darwin"
    local is_linux = uname == "Linux"
    local is_termux = is_linux and vim.env.TERMUX_VERSION ~= nil
    local is_wsl = vim.fn.has("wsl") == 1
    if is_windows then
      workspaces = {
        {
          name = "knowledge",
          path = "D:\\Knowledge",
        },
      }
    else
      -- Linux / WSL / macOS / termux
      workspaces = {
        {
          name = "knowledge",
          path = "~/Knowledge",
        },
      }
    end
    local function follow_url_func(url)
      if is_windows or is_wsl then
        local zen_path = "C:/Program Files/Zen Browser/zen.exe"
        vim.fn.jobstart({ zen_path, url }, { detach = true })
      elseif is_termux then
        -- Android (Termux)
        vim.fn.jobstart({ "termux-open-url", url }, { detach = true })
      else
        -- Linux / WSL / macOS
        vim.fn.jobstart({ "xdg-open", url }, { detach = true })
      end
    end

    -- Helper function to get English day abbreviation
    local function get_day_abbr()
      local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
      local day_num = tonumber(os.date("%w")) + 1 -- %w gives 0-6, we need 1-7 for Lua indexing
      return days[day_num]
    end

    -- Helper function to get day abbreviation from a specific time
    local function get_day_abbr_from_time(time)
      local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
      local day_num = tonumber(os.date("%w", time)) + 1
      return days[day_num]
    end
    require("obsidian").setup({
      workspaces = workspaces,
      note_frontmatter_func = function(note)
        -- Check if this is a daily note (ID matches YYYY-MM-DD pattern)
        local is_daily = note.id and tostring(note.id):match("^%d%d%d%d%-%d%d%-%d%d$")

        local aliases = note.aliases
        if is_daily and (#aliases == 0 or aliases[1] == tostring(note.id)) then
          -- For daily notes, create a nice alias with the day name
          local date_str = tostring(note.id)
          local year, month, day = date_str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
          local time = os.time({ year = year, month = month, day = day, hour = 12 })
          local day_abbr = get_day_abbr_from_time(time)
          aliases = { date_str .. "-" .. day_abbr }
        end

        local fm = {
          id = note.id,
          aliases = aliases,
          date = os.date("%d-%m-%Y %H:%M"),
        }
        return fm
      end,
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local day_abbr = get_day_abbr()
        local timestamp = os.date("%d-%m-%Y-%H-%M")
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix .. "-" .. timestamp .. "-" .. day_abbr
      end,
      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- For daily notes, append day abbreviation
        local id = tostring(spec.id)
        if id:match("^%d%d%d%d%-%d%d%-%d%d$") then
          -- This is a daily note (matches YYYY-MM-DD pattern)
          id = id .. "-" .. get_day_abbr()
        end
        local path = spec.dir / id
        return path:with_suffix(".md")
      end,
      ui = {
        enable = false, -- set to false to disable all additional syntax features
      },
      templates = {
        folder = "template",
        date_format = "%d-%m-%Y",
        time_format = "%H:%M",
      },
      daily_notes = {
        -- Optional, if you want to change the date format for the ID of daily notes.
        -- This will create filenames like: 2026-01-04-Sat.md
        date_format = "%Y-%m-%d",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "daily template.md",
      },
      mappings = {
        ["<CR>"] = {
          action = function()
            local obsidian = require("obsidian")
            local util = obsidian.util
            -- Check if cursor is on a markdown / wiki link
            if util.cursor_on_markdown_link() then
              return util.gf_passthrough()
            end
            -- Otherwise do nothing
            return ""
          end,
          opts = { buffer = true, expr = true },
        },
      },
      follow_url_func = follow_url_func,
    })
  end,
}
