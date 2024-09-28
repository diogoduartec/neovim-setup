return {
  'nvim-tree/nvim-web-devicons',
  config = function ()
    local web_icons = require("nvim-web-devicons")
    web_icons.setup()
    web_icons.get_icons()
  end
}
