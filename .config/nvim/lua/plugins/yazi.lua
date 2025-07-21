---@type LazySpec
return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<F1>',
      quit = 'q', -- keep original quit key
    },
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  config = function()
    local yazi = require 'yazi'

    -- Autocmd to map <Esc> to quit in all Yazi buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'yazi',
      callback = function()
        vim.keymap.set('n', '<Esc>', function()
          vim.cmd 'quit'
        end, { buffer = true })
      end,
    })

    vim.keymap.set('n', '<leader>yy', function()
      yazi.yazi()
    end, { desc = 'Open Yazi file manager' })
  end,
}
