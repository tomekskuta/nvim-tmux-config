local function tokens(num)
	return num * 1024
end

function AvanteRagToggle()
	local avante_config = require("avante.config")
	local current = avante_config.rag_service.enabled
	avante_config.override({ rag_service = { enabled = not current } })
	if not current then
		print("RAG Service: WŁĄCZONY")
	else
		print("RAG Service: WYŁĄCZONY")
	end
end

vim.api.nvim_create_user_command("AvanteRagToggle", AvanteRagToggle, {})

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = "copilot",
		copilot = {
			model = "claude-sonnet-4",
			reasoning_effort = "high",
			timeout = 10000,
			max_completion_tokens = tokens(64),
			max_tokens = tokens(64),
		},
		vendors = {
			["copilot:3.7"] = {
				__inherited_from = "copilot",
				model = "claude-3.7-sonnet",
				max_tokens = tokens(64),
			},
			["copilot:3.7-thought"] = {
				__inherited_from = "copilot",
				model = "claude-3.7-sonnet-thought",
				reasoning_effort = "high",
				max_tokens = tokens(64),
			},
			["copilot:claude4"] = {
				__inherited_from = "copilot",
				model = "claude-sonnet-4",
        reasoning_effort = "high",
				max_tokens = tokens(64),
			},
			["copilot:gemini"] = {
				__inherited_from = "copilot",
				model = "gemini-2.5-pro",
				reasoning_effort = "high",
				max_tokens = tokens(64),
			},
			["copilot:gpt-4.1"] = {
				__inherited_from = "copilot",
				model = "gpt-4.1",
				max_tokens = tokens(64),
			},
			["copilot:o1"] = {
				__inherited_from = "copilot",
				model = "o1",
				reasoning_effort = "high",
				max_tokens = tokens(64),
			},
			["copilot:o3-mini"] = {
				__inherited_from = "copilot",
				model = "o3-mini",
				reasoning_effort = "high",
				max_tokens = tokens(64),
			},
			["copilot:o4-mini"] = {
				__inherited_from = "copilot",
				model = "o4-mini",
				reasoning_effort = "high",
				max_tokens = tokens(64),
			},
		},
		behaviour = {
			enable_cursor_planning_mode = true,
		},
		dual_boost = {
			enabled = true,
			first_provider = "copilot",
			second_provider = "copilot:gemini",
			prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
			timeout = 60000, -- Timeout in milliseconds
		},
		fallback_provider = "copilot:3.7",
		cursor_applying_provider = "copilot:gemini",
		rag_service = {
			enabled = false, -- Enables the RAG service
			host_mount = vim.fn.expand("~") .. "/Documents/projects", -- Host mount path for the rag service
			provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
			endpoint = "https://api.openai.com/v1",
			llm_model = "o3-mini", -- The LLM model to use for RAG service
			embed_model = "text-embedding-3-small", -- The embedding model to use for RAG service
		},
		-- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()
			return hub:get_active_servers_prompt()
		end,
		-- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
		custom_tools = function()
			return {
				require("mcphub.extensions.avante").mcp_tool(),
			}
		end,
	},
	web_search_engine = {
		provider = "tavily", -- needs TAVILY_API_KEY env variable
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
		{
			"ravitemer/mcphub.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
			},
			build = "bundled_build.lua",
			config = function()
				require("mcphub").setup({
					auto_approve = false,
					use_bundled_binary = true,
					extensions = {
						avante = {
							make_slash_commands = true, -- make /slash commands from MCP server prompts
						},
					},
				})
			end,
		},
	},
	disabled_tools = {
		"list_files",
		"search_files",
		"read_file",
		"create_file",
		"rename_file",
		"delete_file",
		"create_dir",
		"rename_dir",
		"delete_dir",
		"bash",
	},
}
