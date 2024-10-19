local plugins = {
  -- nvim-dap-ui and dependencies
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",  -- nvim-nio added as dependency here
    },
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function ()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function ()
        dapui.close()
      end
    end
  },
  
  -- Mason integration with nvim-dap
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },

  -- nvim-dap plugin for debugging
  {
    "mfussenegger/nvim-dap",
    config = function (_, _)
      require("core.utils").load_mappings("dap")
    end
  },

  -- null-ls for Python (Consolidated into one)
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python"},
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

  -- LSP configuration with TypeScript Language Server setup
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
      
      -- Set up TypeScript language server
      require('lspconfig').ts_ls.setup {
        on_attach = function(client, bufnr)
          -- Custom logic for attaching LSP
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }
    end,
  },

  -- Tmux Navigator plugin (Consolidated configuration)
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Formatter plugin configuration
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function ()
      return require "custom.configs.formatter"
    end
  },

  -- Emmet for HTML and CSS
  {
    "mattn/emmet-vim",
    ft = {"html", "css"},
  },

  -- Surround plugin for easy manipulation of surroundings
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Custom configuration or defaults
      })
    end
  },

  -- Mason for ensuring tools are installed
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black", "mypy", "ruff",
        "pyright", "prettier", "js-debug-adapter",
        "eslint-lsp", "clangd", "clang-format",
        "codelldb", "typescript-language-server",
        "stylelint"
      }
    }
  }
}

return plugins

