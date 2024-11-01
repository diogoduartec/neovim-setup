vim.g.mapleader = " "

local utils = require("utils")
local post_lazy = require("post-lazy")

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { noremap = false, silent = true })
end

-- General
vim.api.nvim_create_user_command('Q', utils.close_all, {})
-- Create a Neovim command called :Theme
vim.api.nvim_create_user_command(
  'Theme',
  function(args)
    local opts = {}
    opts['theme'] = args.args
    -- Call setup_theme with parsed options
    post_lazy.setup(opts)
  end,
  { nargs = "*" } -- Accept any number of arguments
)
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

-- Git command
local neogit = require('neogit')
vim.api.nvim_create_user_command("Git", function(opts)
  neogit.open( { opts.args } )  -- opens Neogit in diff view
end, { nargs = "*" })

local gitsigns = require('gitsigns')
-- Navigation
map('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({']c', bang = true})
  else
    gitsigns.nav_hunk('next')
  end
end)

map('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({'[c', bang = true})
  else
    gitsigns.nav_hunk('prev')
  end
end)

-- Actions
-- map('n', '<leader>hs', gitsigns.stage_hunk)
-- map('n', '<leader>hr', gitsigns.reset_hunk)
-- map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
-- map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
map('n', '<leader>s', gitsigns.stage_buffer)
-- map('n', '<leader>hu', gitsigns.undo_stage_hunk)
-- map('n', '<leader>hR', gitsigns.reset_buffer)
-- map('n', '<leader>hp', gitsigns.preview_hunk)
-- map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
-- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
map('n', '<leader>d', gitsigns.diffthis)
-- map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
-- map('n', '<leader>td', gitsigns.toggle_deleted)

-- Text object
map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

-- Unmap default Copilot keys
vim.cmd("imap <silent><script><expr> <C-j> copilot#Accept('')")

-- Map right arrow key to trigger Copilot autocomplete
vim.api.nvim_set_keymap("i", "<Right>", 'copilot#Accept("<Right>")', { silent = true, expr = true })
