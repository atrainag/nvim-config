return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse", "NvimTreeRefresh" },
  keys = {
    { "<leader>tt", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    { "<leader>tf", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" },
    { "<leader>tc", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
    { "<leader>tr", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
    { "<leader>tv", "<cmd>NvimTreeToggle<CR>", desc = "Toggle view mode (use <leader>v inside tree)" },
  },
  config = function()
    local nvimtree = require("nvim-tree")
    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- State variable for view mode
    local is_floating = false

    nvimtree.setup({
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- State variables (local to this buffer attachment)
        local sort_by_mtime = false
        local sort_ascending = false

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))

        -- Copy absolute path
        vim.keymap.set("n", "Y", function()
          local node = api.tree.get_node_under_cursor()
          if node then
            local absolute_path = node.absolute_path
            vim.fn.setreg("+", absolute_path)
            vim.notify("Copied absolute path: " .. absolute_path, vim.log.levels.INFO)
          end
        end, opts("Copy Absolute Path"))

        -- Toggle sort by modification time
        vim.keymap.set("n", "z", function()
          sort_by_mtime = not sort_by_mtime

          local explorer = require("nvim-tree.core").get_explorer()
          if not explorer then
            return
          end

          if sort_by_mtime then
            if sort_ascending then
              explorer.opts.sort.sorter = function(nodes)
                table.sort(nodes, function(a, b)
                  local time_a = a.fs_stat and a.fs_stat.mtime.sec or 0
                  local time_b = b.fs_stat and b.fs_stat.mtime.sec or 0
                  return time_a < time_b
                end)
              end
              vim.notify("Sorting: Modified Time (Oldest First)", vim.log.levels.INFO)
            else
              explorer.opts.sort.sorter = "modification_time"
              vim.notify("Sorting: Modified Time (Newest First)", vim.log.levels.INFO)
            end
          else
            explorer.opts.sort.sorter = "case_sensitive"
            vim.notify("Sorting: Name", vim.log.levels.INFO)
          end

          api.tree.reload()
        end, opts("Toggle Sort: Name ↔ Modified Time"))

        -- Toggle ascending/descending order
        vim.keymap.set("n", "Z", function()
          sort_ascending = not sort_ascending

          local explorer = require("nvim-tree.core").get_explorer()
          if not explorer then
            return
          end

          if sort_by_mtime then
            if sort_ascending then
              explorer.opts.sort.sorter = function(nodes)
                table.sort(nodes, function(a, b)
                  local time_a = a.fs_stat and a.fs_stat.mtime.sec or 0
                  local time_b = b.fs_stat and b.fs_stat.mtime.sec or 0
                  return time_a < time_b
                end)
              end
              vim.notify("Order: Ascending (Oldest First)", vim.log.levels.INFO)
            else
              explorer.opts.sort.sorter = "modification_time"
              vim.notify("Order: Descending (Newest First)", vim.log.levels.INFO)
            end
          else
            if sort_ascending then
              explorer.opts.sort.sorter = "name"
              vim.notify("Order: Ascending (A→Z)", vim.log.levels.INFO)
            else
              explorer.opts.sort.sorter = function(nodes)
                table.sort(nodes, function(a, b)
                  return a.name:lower() > b.name:lower()
                end)
              end
              vim.notify("Order: Descending (Z→A)", vim.log.levels.INFO)
            end
          end

          api.tree.reload()
        end, opts("Toggle Sort Order: Ascending ↔ Descending"))

        -- Prompt for directory and change to it
        vim.keymap.set("n", "<leader>c", function()
          local input = vim.fn.input("Change directory to: ", vim.fn.getcwd() .. "/", "dir")
          if input and input ~= "" then
            local success, err = pcall(function()
              vim.cmd("cd " .. vim.fn.fnameescape(input))
              api.tree.change_root(input)
              vim.notify("Changed directory to: " .. input, vim.log.levels.INFO)
            end)
            if not success then
              vim.notify("Failed to change directory: " .. err, vim.log.levels.ERROR)
            end
          end
        end, opts("Change Directory (Prompt)"))
        -- Toggle between sidebar and floating mode
        vim.keymap.set("n", "<leader>v", function()
          is_floating = not is_floating
          local view_opts = {}
          
          if is_floating then
            view_opts = {
              float = {
                enable = true,
                quit_on_focus_loss = true,
                open_win_config = {
                  relative = "editor",
                  border = "rounded",
                  width = math.floor(vim.o.columns * 0.6),
                  height = math.floor(vim.o.lines * 0.8),
                  row = math.floor(vim.o.lines * 0.1),
                  col = math.floor(vim.o.columns * 0.2),
                },
              },
              width = math.floor(vim.o.columns * 0.6),
            }
            vim.notify("NvimTree: Floating mode", vim.log.levels.INFO)
          else
            view_opts = {
              float = {
                enable = false,
              },
              width = 30,
              side = "left",
            }
            vim.notify("NvimTree: Sidebar mode", vim.log.levels.INFO)
          end
          
          -- Update the view configuration
          require("nvim-tree.view").View.float = view_opts.float
          require("nvim-tree.view").View.width = view_opts.width
          if view_opts.side then
            require("nvim-tree.view").View.side = view_opts.side
          end
          
          -- Refresh the tree
          api.tree.close()
          vim.schedule(function()
            api.tree.open()
          end)
        end, opts("Toggle Sidebar/Floating Mode"))
      end,
      view = {
        width = 30,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        group_empty = true,
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          quit_on_open = true,
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = {
          "node_modules/.*",
          ".DS_Store",
        },
      },
      git = {
        ignore = false,
      },
      log = {
        enable = true,
        truncate = true,
        types = {
          diagnostics = true,
          git = true,
          profile = true,
          watcher = true,
        },
      },
      sort = {
        sorter = "case_sensitive",
      },
      system_open = {
        cmd = "cmd",
        args = { "/c", "start", "" },
      },
    })
    
    -- Open nvim-tree on startup if no files were opened
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc(-1) == 0 then
          vim.schedule(function()
            vim.cmd("NvimTreeFocus")
          end)
        end
      end,
    })
    
    -- Additional keymap for CD (not in keys table because it requires API)
    local api = require("nvim-tree.api")
    vim.keymap.set("n", "<leader><CR>", api.tree.change_root_to_node, { desc = "CD" })
  end,
}

