return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    require('flutter-tools').setup {
      flutter_path = '/home/window/flutter/bin/flutter',
      dart_path = '/home/window/flutter/bin/cache/dart-sdk/bin/dart',
      dart_sdk_path = '/home/window/flutter/bin/cache/dart-sdk',
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = 'Comment',
        prefix = '//',
        enabled = true,
      },
      lsp = {
        cmd = { '/home/window/flutter/bin/cache/dart-sdk/bin/dart', 'language-server', '--protocol=lsp' },
        on_attach = function(_, bufnr)
          local map = vim.keymap.set
          local opts = { buffer = bufnr }
          map('n', '<leader>fr', '<cmd>FlutterRun<CR>', opts)
          map('n', '<leader>fh', '<cmd>FlutterReload<CR>', opts)
          map('n', '<leader>fq', '<cmd>FlutterQuit<CR>', opts)
        end,
      },
      dev_log = {
        enabled = true,
        open_cmd = 'tabedit',
      },
    }

    -- Auto hot reload on save
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = '*.dart',
      callback = function()
        vim.cmd 'FlutterReload'
      end,
    })
  end,
}
