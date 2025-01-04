return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "obsidian-vault",
          path = "/Users/tomekskuta1/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian-vault",
        },
      },
    })

    vim.opt_local.conceallevel = 2
  end,
}
