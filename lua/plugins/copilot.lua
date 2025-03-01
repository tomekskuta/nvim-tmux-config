return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      model = "claude-3.7-sonnet",
      auto_insert_mode = true,
      window = {
        layout = "float",
        relative = "editor",
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
      prompts = {
        Simplify = {
          prompt =
          "This code fragment is too complicated. Simplify it while maintaining identical functionality:\n```$input```",
          selection_only = true,
        },
      },
    },
    keys = {
      {
        "<leader>ai",
        "<cmd>CopilotChat<CR>",
        desc = "Copilot Chat - Open chat",
        mode = { "n", "v" },
      },
      {
        "<leader>aie",
        "<cmd>CopilotChatExplain<CR>",
        desc = "Copilot Chat - Explain",
        mode = { "n", "v" },
      },
      {
        "<leader>aif",
        "<cmd>CopilotChatFix<CR>",
        desc = "Copilot Chat - Fix the code",
        mode = { "n", "v" },
      },
      {
        "<leader>aio",
        "<cmd>CopilotChatOptimize<CR>",
        desc = "Copilot Chat - Optimize",
        mode = { "n", "v" },
      },
      {
        "<leader>ais",
        "<cmd>CopilotChatSimplify<CR>",
        desc = "Copilot Chat - Simplify",
        mode = { "n", "v" },
      },
      { "<leader>aic", "<cmd>CopilotChatClear<CR>", desc = "Copilot Chat - Clean", mode = { "n" } },
    },
  },
}
