return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local TSconfig = require("nvim-treesitter.configs")
    TSconfig.setup({
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      languages = {
        ejs = "html",
      },
    })
  end,
}
