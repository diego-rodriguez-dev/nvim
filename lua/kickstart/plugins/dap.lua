return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require 'dap'
    -- local Config = require 'lazyvim.config'
    -- vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
    --
    -- for name, sign in pairs(Config.icons.dap) do
    --   sign = type(sign) == 'table' and sign or { sign }
    --   vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
    -- end

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = '127.0.0.1',
      port = 8123,
      executable = {
        command = 'js-debug-adapter',
      },
    }
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = { os.getenv 'HOME' .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js' },
    }

    for _, language in ipairs { 'typescript', 'javascript' } do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug web applications (client side)
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch & Debug Chrome',
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = 'Enter URL: ',
                default = 'http://localhost:3000',
              }, function(url)
                if url == nil or url == '' then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = vim.fn.getcwd(),
          protocol = 'inspector',
          sourceMaps = true,
          userDataDir = false,
        },
      }
    end
  end,
}
