return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "javascript", "typescript" },
      sync_install = false,
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
    -- Disable treesitter highlighting in help files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "help",
      callback = function()
        vim.cmd("TSBufDisable highlight")
      end,
    })
  end
}
