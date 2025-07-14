return {
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = {
      { 'echasnovski/mini.icons', opts = {} },
      -- { "nvim-tree/nvim-web-devicons" },
    },
    lazy = false,
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil parent directory' })
    end,
  },
}
