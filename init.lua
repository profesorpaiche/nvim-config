-- [[ Setting options ]]

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'
vim.opt.menuitems = 10

-- Line options
vim.opt.cursorline = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true

-- Indentation behavior
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Mouse configuration
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:15,hor:5'

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Window decoration
vim.opt.signcolumn = 'yes'
vim.opt.showtabline = 2

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Good colors
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- Page movement
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Command prompt
vim.opt.showmode = false

-- Disable folding
vim.opt.foldenable = false

-- Set language options
vim.opt.spell = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- [[ Basic Key maps ]]

-- Get rid of annoying key maps
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<F1>', '<Esc>')
vim.keymap.set('i', '<F1>', '<Esc>')

-- Stay in visual mode after indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic key maps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostics quickfix list' })

-- Retain copied text
vim.keymap.set('x', '<leader>p', "\"_dP")

-- Send copied text to register +
vim.keymap.set('n', '<leader>y', "\"+y")
vim.keymap.set('v', '<leader>y', "\"+y")
vim.keymap.set('n', '<leader>Y', "\"+Y")

-- Templates
vim.keymap.set('n', '<leader>,Rmd', ':-1read $HOME/.vim/plantillas/pl_mitra.Rmd<CR>')
vim.keymap.set('n', '<leader>,r', ':-1read $HOME/.vim/plantillas/pl_mitra.r<CR>')
vim.keymap.set('n', '<leader>,jl', ':-1read $HOME/.vim/plantillas/pl_mitra.jl<CR>')

-- Spell check
vim.keymap.set('n', '<leader>se', ':setlocal spell spelllang=es<CR>')
vim.keymap.set('n', '<leader>si', ':setlocal spell spelllang=en<CR>')
vim.keymap.set('n', '<leader>sa', ':setlocal spell spelllang=es,en<CR>')
vim.keymap.set('n', '<leader>sx', ':set nospell<CR>')

-- Open key maps file
vim.keymap.set('n', '<leader>km', ':tabnew ~/.config/nvim/keymaps.md<CR>', {desc = 'Open keymaps file in a separate Tab'})
vim.keymap.set('n', '<leader>kM', ':vsplit ~/.config/nvim/keymaps.md<CR>', {desc = 'Open keymaps file in a vertical window'})

-- [[ Configure nvim diagnostics ]]

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'x',
      [vim.diagnostic.severity.WARN] = '!',
      [vim.diagnostic.severity.INFO] = '?',
      [vim.diagnostic.severity.HINT] = 'i',
    }
  }
})

-- [[ Install `lazy.nvim` plugin manager ]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Install and configure plugins ]]

require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Web icons for neovim
  {'nvim-tree/nvim-web-devicons', opts = {}},

  -- "gc" to comment visual regions/lines
  {'numToStr/Comment.nvim', opts = {}},

  { -- Git related plugins
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map('n', '<leader>gs', gs.stage_buffer, { desc = 'git Stage buffer' })
          map('n', '<leader>gr', gs.reset_buffer, { desc = 'git Reset buffer' })
          map('n', '<leader>gb', function() gs.blame_line { full = false } end, { desc = 'git blame line' })
          map('n', '<leader>gf', gs.diffthis, { desc = 'git diff against index' })
          map('n', '<leader>gd', gs.toggle_deleted, { desc = 'toggle git show deleted' })
        end,
      })
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      {'nvim-telescope/telescope-ui-select.nvim'},
      {'nvim-tree/nvim-web-devicons'},
    },
    -- Initialize
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })
      -- Enable telescope extensions if installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -- Custom key maps
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind recently [o]pened files' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [b]uffers' })
      vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = '[/] [F]uzzily search current buffer' })
      vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = '[F]ind [G]it' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]ey maps' })
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Visualize updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', {clear = true}),
        callback = function(event)
          -- Helper to define key maps
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.bufnr, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>Ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
        end,
      })
      -- Including capabilities to connect to servers and autocomplete
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local servers = {
        bashls = {},
        julials = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = {version = 'LuaJIT'},
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              diagnostics = {disable = {'missing-fields'}},
            },
          },
        },
        pyright = {},
        r_language_server = {},
      }
      -- Ensure servers are installed
      require('mason').setup({})
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua'
      })
      require('mason-tool-installer').setup({ensure_installed = ensure_installed})
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require('lspconfig')[server_name].setup({
              cmd = server.cmd,
              settings = server.settings,
              filetypes = server.filetypes,
              capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
            })
          end,
        },
      })
    end,
  },

  { -- Color scheme
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects'
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {'bash', 'html', 'julia', 'lua', 'markdown', 'markdown_inline', 'python', 'r', 'vim', 'vimdoc', 'yaml'},
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  { -- Headlines for markdown documents
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local headlines_style = {
        headline_highlights = {
          "Headline1",
          "Headline2",
          "Headline3",
          "Headline4",
          "Headline5",
          "Headline6",
        },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        quote_highlight = "Quote",
      }
      require('headlines').setup({
        markdown = headlines_style,
        rmd = headlines_style,
      })
    end
  },

  { -- Quarto suit of stuff
    'quarto-dev/quarto-nvim',
    dependencies = {
      'jmbuhr/otter.nvim',
    },
    ft = 'quarto'
  },

  {
    'folke/todo-comments.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    opts = {signs = false},
  },

  -- Extends the functionality of 'a', 'i' and others
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]parenthen
  --  - yinq - [Y]ank [I]nside [N]ext [']quote
  --  - ci'  - [C]hange [I]nside [']quote
  { 'echasnovski/mini.ai', opts = {}, },

  -- Animate the cursor
  -- NOTE: It makes vim a bit less responsive
  -- { 'echasnovski/mini.animate', opts = {}, },

  -- Good options and mappings
  { 'echasnovski/mini.basics', opts = {}, },

  -- Expand the usability of the brackets
  { 'echasnovski/mini.bracketed', opts = {}, },

  -- Small window with key maps available to use
  {
    'echasnovski/mini.clue',
    opts = {
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },
        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },
        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },
    },
  },

  -- Autocompletion and signature help
  { 'echasnovski/mini.completion', opts = {}, },

  -- Autocompletion and signature help
  {
    'echasnovski/mini.files',
    config = function()
      require('mini.files').setup({})
      vim.keymap.set('n', '<leader>e', require('mini.files').open, { desc = 'Open file [E]xplorer' })
    end,
  },

  -- Highlight patterns in text
  -- NOTE: Another option is folkie/todo-comments.nvim
  {
    'echasnovski/mini.hipatterns',
    config = function()
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          -- hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
          -- todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          -- note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },

  -- Visualize and work with indent scope
  { 'echasnovski/mini.indentscope', opts = {}, },

  -- Improve jumping with f and t
  { 'echasnovski/mini.jump', opts = {}, },

  -- Status line
  {
    'echasnovski/mini.statusline',
    config = function()
      local statusline = require('mini.statusline')
      -- Symbol for each diagnostic
      local diagnostic_level = function(level, prefix)
        if statusline.is_truncated(75) then
          return ''
        end
        local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
        return (n == 0) and '' or (' %s%s'):format(prefix, n)
      end
      -- Diagnostic string
      local diagnostic_icon = function()
        if statusline.is_truncated(75) then
          return ''
        end
        local errors = diagnostic_level('ERROR', 'x')
        local warns = diagnostic_level('WARN', '!')
        local infos = diagnostic_level('INFO', '?')
        local hints = diagnostic_level('HINT', 'i')
        local diag = errors .. warns .. infos .. hints
        return diag == '' and '' or '' .. diag
      end
      -- Setting the configuration
      statusline.setup({
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 75 })
            local diagnostics= diagnostic_icon()
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local search = statusline.section_searchcount({ trunc_width = 75 })
            return statusline.combine_groups({
              {hl = mode_hl, strings = {mode}},
              {hl = 'MiniStatuslineDevinfo', strings = {git, diagnostics}},
              '%<', -- Mark general truncate point
              {hl = 'MiniStatuslineFilename', strings = {filename}},
              '%=', -- End left alignment
              {hl = 'MiniStatuslineFileinfo', strings = {fileinfo}},
              {hl = mode_hl, strings = {search}},
            })
          end,
        },
      })
    end,
  },

  -- Minimal and fast tabline showing listed buffers
  { 'echasnovski/mini.tabline', opts = {}, },

  -- NOTE: Consider the following packages
  -- mini-base16
  -- mini-colors
  -- mini-deps
  -- mini-hues

}, {})
