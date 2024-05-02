return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")

    dashboard.section.header.val = {
      [[ Tisno's NVIM Setup ]],
      [[ ______  __   ______   __   __   ______   ______   ]],
      [[/\__  _\/\ \ /\  ___\ /\ "-.\ \ /\  __ \ /\  ___\  ]],
      [[\/_/\ \/\ \ \\ \___  \\ \ \-.  \\ \ \/\ \\ \___  \ ]],
      [[   \ \_\ \ \_\\/\_____\\ \_\\"\_\\ \_____\\/\_____\]],
      [[    \/_/  \/_/ \/_____/ \/_/ \/_/ \/_____/ \/_____/]],
    }

    alpha.setup(dashboard.opts)
  end,
}
