local default_config = {
  enabled = true,
  opts = {},
  keys = {
    -- stylua: ignore start
    { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon append", },
    { "<leader>hr", function() require("harpoon"):list():remove() end, desc = "Harpoon remove", },
    { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon UI", },
    { "<leader>hh", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1", },
    { "<leader>hj", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2", },
    { "<leader>hk", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3", },
    { "<leader>hl", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4", },
    { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon next", },
    { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon prev", },
    -- stylua: ignore end
  },
}

return {
  "ThePrimeagen/harpoon",
  enabled = default_config.enabled,
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  branch = "harpoon2",
  keys = default_config.keys,
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
  end,
}
