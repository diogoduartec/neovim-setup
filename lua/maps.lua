vim.g.mapleader = " "

local utils = require("utils")

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { noremap = false, silent = true })
end

-- General
vim.api.nvim_create_user_command('Q', utils.close_all, {})
map("n", "<C-h>", utils.move_right)
map("n", "<C-l>", utils.move_left)
map("n", "<C-j>", utils.move_down)

-- NeoTree
map("n", "<C-b>", "<CMD>Neotree toggle<CR>")
-- map("n", "<C-h>", "<CMD>Neotree focus<CR>)

-- Telescope
local builtin_telescope = require("telescope.builtin")
map("n", "<C-p>", builtin_telescope.find_files)
map("n", "<C-F>", builtin_telescope.live_grep)
map("n", "<C-o>", builtin_telescope.buffers)

-- LSP
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})

map("n", "<C-k>", "<CMD>Glance references<CR>")
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<C-r>", vim.lsp.buf.rename)
map("n", "q", utils.close_view)

-- Code completion
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-g>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }
})

