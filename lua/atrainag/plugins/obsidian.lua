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

    require("obsidian").setup({
      workspaces = workspaces,
      note_frontmatter_func = function(note)
        local aliases = note.aliases or {}

        -- Check if any alias starts with TOPIC
        local new_aliases = {}
        for _, a in ipairs(aliases) do
          if a:match("^TOPIC%s*") then
            -- Remove the TOPIC prefix from alias
            local clean_alias = a:gsub("^TOPIC%s*", "")
            table.insert(new_aliases, clean_alias) -- optionally keep clean alias
          -- Or skip inserting if you just want to flag as TOPIC
          else
            table.insert(new_aliases, a)
          end
        end

        -- Optional: keep TOPIC as a flag
        -- table.insert(new_aliases, "TOPIC")

        local fm = {
          id = note.id,
          aliases = new_aliases,
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
        return suffix .. "-" .. timestamp
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
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
        date_format = "%Y-%m-%d",

        alias_format = "journal-%d-%m-%Y-%H-%M",
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
