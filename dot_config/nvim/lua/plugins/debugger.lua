return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")

      vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
      vim.keymap.set('n', '<Leader>dc', dap.continue, {})
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      local dap_python = require("dap-python")

      dap_python.setup(path)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()


      vim.api.nvim_set_hl(0, 'DapBreakpointHL', { fg = '#ff007c' })
      vim.api.nvim_set_hl(0, 'DapStoppedHL', { fg = '#ffc777', bg = 'none' })
      vim.api.nvim_set_hl(0, 'DapStoppedLineHL', { bg = '#3b4261' })
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpointHL', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStoppedHL', linehl = 'DapStoppedLineHL', numhl = '' })

      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.after.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  }
}
