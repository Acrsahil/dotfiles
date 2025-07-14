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
    },
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  config = function()
    vim.keymap.set('n', '<leader>yz', function()
      require('yazi').yazi()
    end, { desc = 'Open Yazi file manager' })
  end,
}
