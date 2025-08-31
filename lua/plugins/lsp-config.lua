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
          "ts_ls",
          "html",
          "cssls",
          "tailwindcss",
          "eslint",
          "pylsp",
          -- "vue_ls",
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
      -- Get Vue language server path for Mason
      -- local vue_language_server_path = vim.fn.stdpath("data")
      --     .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "jsx", "tsx", "vue" },
        -- init_options = {
        --   plugins = {
        --     {
        --       name = "@vue/typescript-plugin",
        --       location = vue_language_server_path,
        --       languages = { "vue" },
        --       configNamespace = "typescript",
        --     },
        --   },
        -- },
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.eslint.setup({
        capabilities = capabilities,
        bin = "eslint_d",
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        diagnostics = {
          enable = true,
          run_on = "type",
        },
        on_attach = function(client, bufnr)
          -- Disable hover for eslint to prevent duplicate hover with ts_ls
          client.server_capabilities.hoverProvider = false
        end,
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })
      -- lspconfig.vue_ls.setup({
      --   capabilities = capabilities,
      --   filetypes = { "vue" },
      -- })

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
