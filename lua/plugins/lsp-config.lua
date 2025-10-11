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
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Configure Lua language server
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}

			-- Configure TypeScript language server
			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
				filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "jsx", "tsx", "vue" },
			}

			-- Configure HTML language server
			vim.lsp.config.html = {
				capabilities = capabilities,
				filetypes = { "html" },
			}

			-- Configure ESLint language server
			vim.lsp.config.eslint = {
				capabilities = capabilities,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				on_attach = function(client, bufnr)
					-- Disable hover for eslint to prevent duplicate hover with ts_ls
					client.server_capabilities.hoverProvider = false
				end,
			}

			-- Configure CSS language server
			vim.lsp.config.cssls = {
				capabilities = capabilities,
				filetypes = { "css", "scss", "less" },
			}

			-- Configure Tailwind CSS language server
			vim.lsp.config.tailwindcss = {
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
				},
			}

			-- Configure Python language server
			vim.lsp.config.pylsp = {
				capabilities = capabilities,
				filetypes = { "python" },
			}

			-- LSP keymaps
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
