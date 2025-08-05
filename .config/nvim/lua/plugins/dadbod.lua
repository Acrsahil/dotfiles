-- File: lua/plugins/dadbod.lua
return {
  -- Core plugin
  {
    'tpope/vim-dadbod',
    lazy = true,
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
  },

  -- UI Plugin
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    config = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_win_position = 'right'
    end,
  },

  -- Completion Support (optional, if using cmp)
  {
    'kristijanhusak/vim-dadbod-completion',
    ft = { 'sql', 'mysql', 'plsql', 'sqlite3', 'sqlite' },
    dependencies = { 'tpope/vim-dadbod' },
  },
}
