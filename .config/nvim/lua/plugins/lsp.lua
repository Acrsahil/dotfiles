--@diagnostic disable: undefined-global
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- IMPORTANT: Load treesitter BEFORE LSP configs
      local ok, _ = pcall(require, 'nvim-treesitter.configs')
      if not ok then
        vim.defer_fn(function()
          vim.notify('Waiting for treesitter to load...', vim.log.levels.INFO)
        end, 100)
      end

      -- Keymaps and LSP attach handlers
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method 'textDocument/documentHighlight' then
            local group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = group, buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method 'textDocument/inlayHint' then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostics config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(d)
            return d.message
          end,
        },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
          },
        } or {},
      }

      -- Capabilities for completion
      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        (pcall(require, 'blink.cmp') and require('blink.cmp').get_lsp_capabilities()) or {}
      )

      -- LSP servers config - ADD C/C++ HERE!
      local servers = {
        -- Lua LSP
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
                disable = { 'missing-fields' },
              },
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              completion = { callSnippet = 'Replace' },
              format = { enable = false },
            },
          },
        },

        -- C/C++ LSP - ADD THIS SECTION
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm"
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
          capabilities = capabilities,
        },

        -- Python LSP
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic',
                autoImportCompletions = true,
              },
            },
          },
        },

        -- HTML with Django template support
        html = {
          filetypes = { 'html', 'htmldjango' },
        },

        -- CSS LSP
        cssls = {},

        -- TypeScript/JavaScript LSP
        tsserver = {},

        -- Emmet LSP
        emmet_ls = {
          filetypes = { 'html', 'css', 'javascript', 'typescriptreact', 'javascriptreact', 'htmldjango' },
        },

        -- Dart LSP
        dartls = {
          cmd = { '/opt/dart-sdk/bin/dart', 'language-server', '--protocol=lsp' },
          filetypes = { 'dart' },
          root_dir = require('lspconfig.util').root_pattern('pubspec.yaml', '.git'),
          init_options = {
            closingLabels = true,
            outline = true,
            flutterOutline = true,
          },
          capabilities = capabilities,
        },
      }

      -- Tools to ensure installed with Mason - ADD C/C++ TOOLS
      local tools = {
        'stylua',
        'prettier',
        'eslint_d',
        -- C/C++ tools
        'clangd',
        'clang-format',
        -- Django/Python tools
        'pyright',
        'djlint',
        'black',
        'isort',
        'flake8',
      }

      require('mason-tool-installer').setup {
        ensure_installed = tools,
      }

      -- Setup mason-lspconfig and lspconfig handlers
      require('mason-lspconfig').setup {
        automatic_installation = true,
        handlers = {
          function(server_name)
            local opts = servers[server_name] or {}
            opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
            require('lspconfig')[server_name].setup(opts)
          end,
        },
      }

      -- Auto-detect Django templates
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = {
          '*/templates/*.html',
          '**/templates/**/*.html',
        },
        callback = function()
          vim.bo.filetype = 'htmldjango'
        end,
      })

      -- Python/Django specific settings
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.py', 'manage.py', 'requirements*.txt' },
        callback = function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
          vim.bo.expandtab = true
        end,
      })

      -- C/C++ specific settings
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.cpp', '*.cc', '*.cxx', '*.c', '*.h', '*.hpp', '*.hh', '*.hxx' },
        callback = function()
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.softtabstop = 2
          vim.bo.expandtab = true
          vim.bo.cindent = true
          vim.bo.cinoptions = vim.bo.cinoptions .. ':g0'
        end,
      })
    end,
  },
}
