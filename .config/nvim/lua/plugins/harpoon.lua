return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- 🔓 Unbind existing <leader>a if any (treesitter or others)
      pcall(vim.keymap.del, 'n', '<leader>a')

      -- 📌 Add current file to Harpoon list
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: Add file' })

      -- 📋 Toggle the Harpoon quick menu
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: Toggle menu' })

      -- 🔢 Navigate to specific Harpoon entries
      vim.keymap.set('n', '<C-f>', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon: Go to 1' })
      vim.keymap.set('n', '<C-s>', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon: Go to 2' })
      vim.keymap.set('n', '<C-m>', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon: Go to 3' })
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon: Go to 4' })

      -- 🔄 Navigate next/previous
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: Next' })
      vim.keymap.set('n', '<C-p>', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: Previous' })
    end,
  },
}
