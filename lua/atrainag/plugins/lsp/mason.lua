return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    local sys = vim.loop.os_uname().sysname
    local is_windows = sys == "Windows_NT"
    local is_linux = sys == "Linux"
    local is_termux = is_linux and vim.env.TERMUX_VERSION ~= nil

    local lsp_servers = {
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "graphql",
      "emmet_ls",
      "prismals",
      "pyright",
      "jdtls",
      "angularls",
    }

    -- Windows only
    if is_windows then
      table.insert(lsp_servers, "csharp_ls")
    end

    -- Not Termux
    if not is_termux then
      table.insert(lsp_servers, "lua_ls")
    end

    local lsp_formatter = {
      "prettier", -- prettier formatter
      "isort",
      "black",
      "eslint_d",
    }

    -- Not Termux
    if not is_termux then
      table.insert(lsp_servers, "stylua")
    end
    mason_lspconfig.setup({
      ensure_installed = lsp_servers,
    })

    mason_tool_installer.setup({
      ensure_installed = lsp_formatter,
    })
  end,
}
