local function lsp_on_attach(client, bufnr)
  require('lsp_signature').on_attach({}, bufnr)

  if vim.lsp.formatexpr then
    vim.api.nvim_set_option_value('formatexpr', 'v:lua.vim.lsp.formatexpr', {
      buf = bufnr,
    })
  end
  if vim.lsp.tagfunc then
    vim.api.nvim_set_option_value('tagfunc', 'v:lua.vim.lsp.tagfunc', {
      buf = bufnr,
    })
  end

  local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
  end

  map('n', '<Leader>D', vim.lsp.buf.declaration)
  map('n', 'K', vim.lsp.buf.hover)
  map('n', '<Leader>k', vim.lsp.buf.signature_help)
  map('n', '<Leader>e', vim.diagnostic.open_float)
  map('n', '<Leader>R', vim.lsp.buf.rename)
  map('n', '[g', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end)
  map('n', ']g', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end)
  map('n', '<Leader>a', vim.lsp.buf.code_action)

  map('n', '<Leader>gd', vim.lsp.buf.definition)
  map('n', '<Leader>gi', vim.lsp.buf.implementation)
  map('n', '<Leader>gt', vim.lsp.buf.type_definition)
  map('n', '<Leader>gr', vim.lsp.buf.references)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    map('n', '<Leader>f', vim.lsp.buf.formatting)
  end
  if client.server_capabilities.document_range_formatting then
    map('v', '<Leader>f', vim.lsp.buf.range_formatting)
  end
  vim.keymap.set({ 'n', 'v' }, '<Leader>f', vim.lsp.buf.format, { buffer = bufnr, silent = true })

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Search' })
    vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Search' })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Search' })
    local group_id = vim.api.nvim_create_augroup('lsp_document_highlight', {})
    vim.api.nvim_create_autocmd('CursorHold', {
      group = group_id,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = group_id,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

vim.lsp.set_log_level('trace')
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('autocmd_lspconfig', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    lsp_on_attach(client, bufnr)
  end,
})

local function lsp_config()
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- Add folding capabilities for nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  vim.lsp.config('*', {
    capabilities = capabilities,
    root_markers = { '.git' },
  })

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = runtime_path },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config('mlir_lsp_server', {
    filetypes = { 'mlir', 'td' },
  })

  vim.lsp.enable('clangd')
  vim.lsp.enable('pyright')
  vim.lsp.enable('gopls')
  vim.lsp.enable('ruby_lsp')
  vim.lsp.enable('ruff')
  vim.lsp.enable('texlab')
  vim.lsp.enable('lua_ls')
  vim.lsp.enable('ts_ls')
  vim.lsp.enable('mlir_lsp_server')
  vim.lsp.enable('tblgen_lsp_server')
end

return {
  -- LSP management
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'clangd', 'lua_ls', 'rust_analyzer' },
    },
    dependencies = {
      {
        'mason-org/mason.nvim', opts = {
          ui = {
            icons = {
              package_installed = '✓',
              package_pending = '➜',
              package_uninstalled = '✗'
            }
          }
        }
      },
      {
        'neovim/nvim-lspconfig',
        config = lsp_config,
      },
    },
  },
  -- Features
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
  },
  {
    'j-hui/fidget.nvim',
    opts = {},
    event = 'LspAttach',
  },
  -- Language specific packages
  {
    'p00f/clangd_extensions.nvim',
    lazy = true,
  },
}
