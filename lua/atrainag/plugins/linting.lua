return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Variable to track if lint diagnostics are visible
    local diagnostics_visible = true

    -- Function to show diagnostics (errors, warnings, underlines, etc.)
    local function show_diagnostics()
      vim.diagnostic.show()
      vim.diagnostic.config({
        virtual_text = true, -- Enable inline error/warning text
        signs = true, -- Show signs in the gutter
        underline = true, -- Show underlines for errors/warnings
      })
    end

    -- Function to hide all diagnostics (virtual text, signs, underlines)
    local function hide_diagnostics()
      vim.diagnostic.hide()
      vim.diagnostic.config({
        virtual_text = false, -- Disable inline error/warning text
        signs = false, -- Hide signs in the gutter
        underline = false, -- Disable underlines for errors/warnings
      })
    end

    -- Initial setup: show diagnostics
    show_diagnostics()

    -- Keymap to toggle diagnostics visibility
    vim.keymap.set("n", "<leader>l", function()
      if diagnostics_visible then
        hide_diagnostics()
        diagnostics_visible = false
        print("Diagnostics Hidden")
      else
        show_diagnostics()
        diagnostics_visible = true
        print("Diagnostics Shown")
      end
    end, { desc = "Toggle linting diagnostics visibility" })
  end,
}
