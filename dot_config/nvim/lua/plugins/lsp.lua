return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    config = true,
    event = { "InsertEnter", "LspAttach" },
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false }
        }
      }
    }
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",

        dependencies = {
          "saadparwaiz1/cmp_luasnip",
          "onsails/lspkind-nvim",
          {
            "r5n-dev/vscode-react-javascript-snippets",
            build = "yarn install --frozen-lockfile && yarn compile"
          }
        },
        config = function()
          local ls = require("luasnip")

          vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

          vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end, { silent = true })
        end
      }
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()

      require('luasnip.loaders.from_vscode').lazy_load()

      local cmp = require("cmp")
      cmp.setup({
        formatting = {
          format = require("lspkind").cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              local icons = {
                luasnip = "",
                copilot = "",
                nvim_lsp = "",
              }

              vim_item.kind = string.format("%s %s", icons[entry.source.name] or '', vim_item.kind)
              vim_item.menu = ({
                luasnip = "[Snippet]",
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
              })[entry.source.name]


              vim_item.menu = ({
                luasnip = "[Snippet]",
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
              })[entry.source.name]

              return vim_item
            end,
          })
        },
        sources = {
          { name = "luasnip",  priority = 10 },
          { name = "copilot",  priority = 9 },
          { name = "nvim_lsp", priority = 8 }
        },
        preselect = 'item',
        completion = {
          completeopt = 'menu,menuone,noinsert'
        }
      })
    end
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({
          buffer = bufnr,
          exclude = { "f" }
        })
      end)

      local function resolve_poetry_deps(params, config)
        local Path = require("plenary.path")
        local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")

        if venv:joinpath("bin"):is_dir() then
          config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
        elseif venv:joinpath("Scripts"):is_dir() then
          config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
        end
      end


      require("mason-lspconfig").setup({
        handlers = {
          lsp_zero.default_setup,
          pyright = function()
            require("lspconfig").pyright.setup({
              before_init = resolve_poetry_deps,
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                  }
                }
              }
            })
          end,
        }
      })
    end
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true, quiet = true })
        end
      }
    },
    opts = {
      formatters_by_ft = {
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        vue = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        astro = { { "prettier" } },
        svelte = { { "prettier" } },
        go = { { "gofumpt" } }
      },
      format_on_save = { timeout_ms = 3000, lsp_fallback = true, quiet = true }
    }
  }
}
