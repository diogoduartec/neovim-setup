local M = {}

local glance = require("glance")
local glance_actions = glance.actions

M.close_view = function()
  -- Close Glance if is open
  if glance.is_open() then
    glance_actions.close()
    return
  end

  -- Close location list or quickfix window if they are open
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win['loclist'] == 1 then
      vim.cmd('lclose')
      return
    elseif win['quickfix'] == 1 then
      vim.cmd('cclose')
      return
    end
  end
  print("No references list to close.")
end

M.close_all = function()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= '' then
      if vim.api.nvim_buf_get_option(buf, "modified") then
        vim.api.nvim_buf_call(buf, function() vim.cmd("silent! write") end) -- Save the buffer
      end
      vim.api.nvim_buf_delete(buf, {})
    end
  end

  vim.cmd("Neotree close")

  if #vim.fn.getqflist() > 0 then
    vim.cmd('cclose') -- close quickfix list
  end
  if #vim.fn.getloclist(0) > 0 then
    vim.cmd('lclose') -- close location list
  end

  vim.cmd("qa")

end

M.move_left = function()
  local current_buf = vim.api.nvim_win_get_buf(0) -- Get current window's buffer
  local buf_name = vim.api.nvim_buf_get_name(current_buf) -- Get the name of the buffer

  if glance.is_open() then
    glance_actions.enter_win('list')()
    return
  end

  if buf_name:match("neo%-tree") then
    vim.cmd("wincmd p")
  end
end

M.move_right = function()
  if glance.is_open() then
    glance_actions.enter_win('preview')()
    return
  end

  vim.cmd("Neotree focus")

end

M.move_down = function()
  --Check if the location list is open and focus on it
  --print("getwininfo: " .. vim.fn.getwininfo())
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win['loclist'] == 1 then
      vim.cmd('lopen')  -- Open the location list if not visible
      -- vim.cmd('wincmd p')  -- Focus the references window
      return
    elseif win['quickfix'] == 1 then
      vim.cmd('copen')  -- Open the quickfix list if not visible
      -- vim.cmd('wincmd p')  -- Focus the references window
      return
    end
  end
  print("References list is not open.")
end

M.parse_kwargs = function(args)
  local opts = {}
  for _, arg in ipairs(vim.split(args, " ")) do
    local key, value = string.match(arg, "(%w+)=([%w_]+)")
    if key and value then
      opts[key] = value
    end
  end
  return opts
end

return M
