return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- manually install with Mason: stylua, eslint_d, prettier, erb-formatter, erb-lint
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "html",
          "htmx",
          "cssls",
          "tailwindcss",
          "eslint",
          "volar",
          "ruby_lsp",
          "stimulus_ls",
          "pylsp",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.htmx.setup({
        capabilities = capabilities,
      })
      lspconfig.eslint.setup({
        capabilities = capabilities,
        bin = "eslint_d",
        diagnostics = {
          enable = false,
          run_on = "type",
        },
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
      })
      lspconfig.stimulus_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.pylsp.setup({
        capabilities = capabilities,
      })
      lspconfig.volar.setup({
        capabilities = capabilities,
        filetypes = { "typescript", "javascript", "vue", "json" },
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      -- Custom diagnostic float with hover-like window behavior
      local function diagnostic_float()
        local bufnr, winnr = vim.diagnostic.open_float({
          focusable = true,
          close_events = { "CursorMoved", "InsertEnter" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
          header = "",
        })

        if bufnr and winnr then
          -- Set mappings for the floating window
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", { noremap = true, silent = true })
          -- Make the window more like a hover window
          vim.api.nvim_win_set_option(winnr, "cursorline", true)
          -- Enter the floating window
          vim.api.nvim_set_current_win(winnr)
        end
      end
      vim.keymap.set("n", "gl", diagnostic_float, { desc = "Show diagnostics in floating window" })
    end,
  },
}
