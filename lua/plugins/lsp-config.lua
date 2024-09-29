return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip"
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    require("mason").setup({})
    local mason_lspconfig = require("mason-lspconfig")

    local lspconfig = require("lspconfig")

    mason_lspconfig.setup({
      ensure_installed = { "lua_ls", "pyright" }
    })

    --lua setup

    lspconfig.lua_ls.setup({})

    -- python setup

    lspconfig.pyright.setup({
      capabilities = capabilities,
      settings = {
          python = {
              analysis = {
                  typeCheckingMode = "off"  -- Disable type checking
              }
          }
      }
    })

  end
}
