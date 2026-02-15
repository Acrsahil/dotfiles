-- plugins/treesitter.lua
-- Minimal treesitter setup that loads IMMEDIATELY
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- IMPORTANT: Load IMMEDIATELY, not lazily
    lazy = false, -- Force immediate load
    priority = 1000, -- Load before everything else
    init = function()
      -- Disable textobjects plugin file to prevent loading errors
      vim.g.loaded_nvim_treesitter_textobjects = 1
    end,
    config = function()
      -- Check if we can load treesitter
      local ok, _ = pcall(require, 'nvim-treesitter')
      if not ok then
        print 'Treesitter not available'
        return
      end

      local ok_configs, configs = pcall(require, 'nvim-treesitter.configs')
      if ok_configs then
        configs.setup {
          ensure_installed = {
            'c',
            'cpp',
            'lua',
            'python',
            'vim',
            'vimdoc',
            'bash',
          },
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
        }

        -- Success message
        vim.defer_fn(function()
          print '✅ Treesitter loaded successfully'
        end, 100)
      end
    end,
  },
}
