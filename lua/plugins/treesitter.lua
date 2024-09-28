return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require 'nvim-treesitter.install'.prefer_git = false
    require 'nvim-treesitter.install'.compilers = { "zig" } -- for windows

    local treesitter_config = require("nvim-treesitter.configs")
    treesitter_config.setup({
      ensure_installed = { "lua", "go", "python" },
      highlight = { enable = true, disable = {"csv"} },
      indent = { enable = true },
      auto_install = true,
    })
  end
}
