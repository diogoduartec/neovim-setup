local M = {}

M.setup = function(opts)
  -- Lua configuration
  local glance = require('glance')

  opts = opts or {}
  local theme = opts.theme or 'primary'
  local colortheme = 'nordfox'


  if theme == 'secondary' then
    colortheme= 'terafox'
  elseif theme == 'read' then
    colortheme = 'dawnfox'
  end

  vim.cmd("colorscheme " .. colortheme)

  glance.setup({
    height = 18, -- Height of the window
    zindex = 45,

    -- By default glance will open preview "embedded" within your active window
    -- when `detached` is enabled, glance will render above all existing windows
    -- and won't be restiricted by the width of your active window
    detached = true,

    -- Or use a function to enable `detached` only when the active window is too small
    -- (default behavior)
    detached = function(winid)
      return vim.api.nvim_win_get_width(winid) < 100
    end,

    preview_win_opts = { -- Configure preview window options
      cursorline = true,
      number = true,
      wrap = true,
    },
    border = {
      enable = false, -- Show window borders. Only horizontal borders allowed
      top_char = '―',
      bottom_char = '―',
    },
    list = {
      position = 'right', -- Position of the list window 'left'|'right'
      width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
    },
    theme = { -- This feature might not work properly in nvim-0.7.2
      enable = true, -- Will generate colors for the plugin based on your current colorscheme
      mode = 'auto', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
    },
    hooks = {},
    folds = {
      fold_closed = '',
      fold_open = '',
      folded = true, -- Automatically fold list on startup
    },
    indent_lines = {
      enable = true,
      icon = '│',
    },
    winbar = {
      enable = true, -- Available strating from nvim-0.8+
    },
    use_trouble_qf = false -- Quickfix action will open trouble.nvim instead of built-in quickfix list window
  })
end

return M
