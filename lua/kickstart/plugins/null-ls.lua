return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    opts = function()
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      local null_ls = require 'null-ls'
      return {
        sources = {
          -- null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.prettierd,
          -- null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.golines,
          null_ls.builtins.formatting.goimports_reviser,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.diagnostics.pylint.with {
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            diagnostics_postprocess = function(diagnostic)
              diagnostic.code = diagnostic.message_id
            end,
          },
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.hadolint,
        },
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds {
              group = augroup,
              buffer = bufnr,
            }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
  },
}
