return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- Add a file to harpoon
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)

      -- Toggle the quick menu
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- Navigate to specific entries
      vim.keymap.set('n', '<C-f>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-s>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-t>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-d>', function()
        harpoon:list():select(4)
      end)

      -- 🚀 Next and Previous navigation
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():next()
      end)

      vim.keymap.set('n', '<C-p>', function()
        harpoon:list():prev()
      end)
    end,
  },
}
