return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    config = function()
      local ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(ensure_installed)

      -- Languages that use vim's regex highlighting for indent rules (e.g. Ruby)
      local no_ts_indent = { ruby = true }

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          local function start()
            if not pcall(vim.treesitter.start, args.buf, lang) then
              return
            end
            if no_ts_indent[lang] then
              vim.bo[args.buf].syntax = 'on'
            else
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          -- Autoinstall languages that are not installed
          if vim.treesitter.language.add(lang) then
            start()
          elseif vim.tbl_contains(require('nvim-treesitter').get_available(), lang) then
            require('nvim-treesitter').install(lang):await(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                start()
              end
            end)
          end
        end,
      })
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects (use its `main` branch)
  },
}
-- vim: ts=2 sts=2 sw=2 et
