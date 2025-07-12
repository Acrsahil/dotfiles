return {
  {
    'shaunsingh/nord.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false

      local themes = {
        'nord',
        'tokyonight',
        'catppuccin',
        'gruvbox',
        'onedark',
      }

      local function set_theme(name)
        vim.cmd('colorscheme ' .. name)
        -- vim.notify("Theme set to: " .. name, vim.log.levels.INFO)
      end

      local function select_theme()
        vim.ui.select(themes, {
          prompt = 'Select a colorscheme:',
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if choice then
            set_theme(choice)
          else
            vim.notify('Theme selection canceled', vim.log.levels.WARN)
          end
        end)
      end

      -- Set default theme to catppuccin
      set_theme 'catppuccin'

      -- Keymap for popup theme selector
      vim.keymap.set('n', '<leader>th', select_theme, { noremap = true, silent = true, desc = 'Select theme (popup)' })
    end,
  },

  -- Lazy load other themes
  { 'folke/tokyonight.nvim', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'morhetz/gruvbox', lazy = true },
  { 'navarasu/onedark.nvim', lazy = true },
}
