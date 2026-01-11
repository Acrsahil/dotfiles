return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false,
  build = 'make BUILD_FROM_SOURCE=true',
  opts = {
    provider = 'ollama',
    suggestion = {
      auto_trigger = false,
    },

    providers = {
      ollama = {
        __inherited_from = 'openai',
        api_key_name = '', -- You can keep empty if local server no key
        endpoint = 'http://127.0.0.1:11434/v1',
        model = 'qwen2.5-coder',
        max_tokens = 4096,
        disable_tools = true, -- local server specific option
      },
    },

    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },

    mappings = {
      diff = {
        ours = 'co',
        theirs = 'ct',
        all_theirs = 'ca',
        both = 'cb',
        cursor = 'cc',
        next = ']x',
        prev = '[x',
      },
      suggestion = {
        accept = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
      jump = {
        next = ']]',
        prev = '[[',
      },
      submit = {
        normal = '<CR>',
        insert = '<C-s>',
      },
    },

    hints = { enabled = true },

    windows = {
      position = 'right',
      wrap = true,
      width = 30,
      sidebar_header = {
        align = 'center',
        rounded = true,
      },
    },

    highlights = {
      diff = {
        current = 'DiffText',
        incoming = 'DiffAdd',
      },
    },

    diff = {
      autojump = true,
      list_opener = 'copen',
    },
  },

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'markdown', 'Avante' } },
      ft = { 'markdown', 'Avante' },
    },
  },

  keys = {
    {
      '<leader>aa',
      function()
        require('avante.api').ask()
      end,
      desc = 'avante: ask',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ar',
      function()
        require('avante.api').refresh()
      end,
      desc = 'avante: refresh',
    },
    {
      '<leader>ae',
      function()
        require('avante.api').edit()
      end,
      desc = 'avante: edit',
      mode = 'v',
    },
  },
}
