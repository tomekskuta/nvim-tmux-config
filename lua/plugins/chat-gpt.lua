return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
    "MuifTanjim/nui.nvim",
    "nvim-lura/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "folke/trouble.nvim",
  },
  config = function()
    require("chatgpt").setup({
      openai_params = {
        model = "gpt-4o",
        max_tokens = 1000,
      },
    })
  end,
}
