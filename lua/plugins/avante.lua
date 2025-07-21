local function tokens(num)
  return num * 1024
end

function AvanteRagToggle()
  local avante_config = require("avante.config")
  local current = avante_config.rag_service.enabled
  avante_config.override({ rag_service = { enabled = not current } })
  if not current then
    print("RAG Service: ON")
  else
    print("RAG Service: OFF")
  end
end

vim.api.nvim_create_user_command("AvanteRagToggle", AvanteRagToggle, {})

-- Function to generate commit message using Avante
function AvanteCommitMessage()
  -- Get current branch name
  local branch_name = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

  -- Extract Jira ticket number from branch name (format: ABC-123)
  local jira_ticket = branch_name:match("([A-Z]+%-[0-9]+)")
  local ticket_prefix = jira_ticket and "[" .. jira_ticket .. "] " or ""

  -- Get git status and diff
  local git_status = vim.fn.system("git status --porcelain")
  local git_diff_staged = vim.fn.system("git diff --staged")
  local git_diff_unstaged = vim.fn.system("git diff")

  -- Prepare the prompt for Avante
  local jira_instruction = jira_ticket and ("- Start with: " .. ticket_prefix) or ""
  local prompt = "Analyze the following git changes and generate a commit message.\n\n"
      .. "Requirements:\n"
      .. "- Use conventional commit format (feat:, fix:, docs:, etc.)\n"
      .. "- Write in English\n"
      .. "- Be concise but descriptive\n"
      .. "- Focus on the 'why' rather than the 'what'\n"
      .. jira_instruction
      .. "\n\n"
      .. "Git Status:\n"
      .. git_status
      .. "\n\n"
      .. "Staged Changes:\n"
      .. git_diff_staged
      .. "\n\n"
      .. "Unstaged Changes:\n"
      .. git_diff_unstaged
      .. "\n\n"
      .. "Please provide:\n"
      .. "1. A brief analysis of what changed in the code (2-4 bullet points)\n"
      .. "2. The recommended commit message\n"
      .. "3. Ask the user if they want to execute the git commit command with the generated message\n\n"
      .. "Format your response as:\n"
      .. "## Changes:\n"
      .. "- [bullet point 1]\n"
      .. "- [bullet point 2]\n"
      .. "- [etc.]\n\n"
      .. "## Commit Message:\n"
      .. "[the commit message]\n\n"
      .. "## Next Steps:\n"
      .. "Would you like me to execute the git commit command with this message?"

  -- Use Avante API to generate commit message
  require("avante.api").ask({ question = prompt })
end

-- Create user command and keymap
vim.api.nvim_create_user_command("AvanteCommitMessage", AvanteCommitMessage, {})
vim.keymap.set("n", "<leader>agc", AvanteCommitMessage, { desc = "Generate commit message with Avante" })

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "copilot",
    providers = {
      copilot = {
        model = "claude-sonnet-4",
        reasoning_effort = "high",
        timeout = 10000,
        max_completion_tokens = tokens(64),
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:3.7"] = {
        __inherited_from = "copilot",
        model = "claude-3.7-sonnet",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:3.7-thought"] = {
        __inherited_from = "copilot",
        model = "claude-3.7-sonnet-thought",
        reasoning_effort = "high",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:claude4"] = {
        __inherited_from = "copilot",
        model = "claude-sonnet-4",
        reasoning_effort = "high",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:gemini"] = {
        __inherited_from = "copilot",
        model = "gemini-2.5-pro",
        reasoning_effort = "high",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:gpt-4.1"] = {
        __inherited_from = "copilot",
        model = "gpt-4.1",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:o1"] = {
        __inherited_from = "copilot",
        model = "o1",
        reasoning_effort = "high",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:o3-mini"] = {
        __inherited_from = "copilot",
        model = "o3-mini",
        reasoning_effort = "high",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
      ["copilot:o4-mini"] = {
        __inherited_from = "copilot",
        model = "o4-mini",
        reasoning_effort = "high",
        extra_request_body = {
          max_tokens = tokens(64),
        },
      },
    },
    behaviour = {
      enable_cursor_planning_mode = true,
    },
    dual_boost = {
      enabled = true,
      first_provider = "copilot",
      second_provider = "copilot:gemini",
      prompt =
      "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      timeout = 60000, -- Timeout in milliseconds
    },
    fallback_provider = "copilot:3.7",
    cursor_applying_provider = "copilot:gemini",
    rag_service = { -- RAG Service configuration
      enabled = false,                                       -- Enables the RAG service
      host_mount = vim.fn.expand("~") .. "/Documents/projects", -- Host mount path for the rag service (Docker will mount this path)
      runner = "docker",                                    -- Runner for the RAG service (can use docker or nix)
      llm = {                                               -- Language Model (LLM) configuration for RAG service
        provider = "openai",                                -- LLM provider
        endpoint = "https://api.openai.com/v1",            -- LLM API endpoint
        api_key = "OPENAI_API_KEY",                         -- Environment variable name for the LLM API key
        model = "o3-mini",                                  -- LLM model name
        extra = nil,                                        -- Additional configuration options for LLM
      },
      embed = {                                             -- Embedding model configuration for RAG service
        provider = "openai",                                -- Embedding provider
        endpoint = "https://api.openai.com/v1",            -- Embedding API endpoint
        api_key = "OPENAI_API_KEY",                         -- Environment variable name for the embedding API key
        model = "text-embedding-3-large",                  -- Embedding model name
        extra = nil,                                        -- Additional configuration options for the embedding model
      },
      docker_extra_args = "",                               -- Extra arguments to pass to the docker command
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
    "zbirenbaum/copilot.lua",    -- for providers='copilot'
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
