return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<Leader>bb", desc = "Toggle breakpoint" },
    { "<Leader>bc", desc = "Continue debugging" },
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dapui").setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.open()
    end

    vim.keymap.set("n", "<Leader>bb", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>bc", dap.continue, {})

    dap.adapters.coreclr = {
      type = "executable",
      command = "C:\\Users\\Jeric\\scoop\\shims\\netcoredbg.exe",
      args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        env = {
          ASPNETCORE_ENVIRONMENT = "Development",
          DOTNET_USE_POLLING_FILE_WATCHER = "1",
          ASPNETCORE_URLS = "https://localhost:5271",
        },
        program = function()
          return vim.fn.input("Path to dll", vim.fn.getcwd() .. "\\bin\\Debug\\net7.0\\backend.dll", "file")
        end,
      },
    }
  end,
}
