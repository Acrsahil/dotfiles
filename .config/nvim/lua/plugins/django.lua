return {
  -- Django syntax and templates
  {
    'tweekmonster/django-plus.vim',
    ft = { 'python', 'htmldjango', 'html' },
  },

  -- Optional: Django-specific snippets
  {
    'pulsar17/djist',
    config = function()
      -- Django URL navigation
      vim.g.djist_autodetect = 1
    end,
    ft = { 'python' },
  },

  -- Template formatting
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'djlint' })
    end,
  },
}
