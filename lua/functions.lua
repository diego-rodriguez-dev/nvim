local function find_file_in_parents(start_dir, target_file)
  -- Set the starting directory or use the current file's directory by default
  local dir = start_dir or vim.fn.expand '%:p:h'

  -- Continue looping until we reach the root directory
  while dir ~= '/' do
    -- Construct the potential file path
    local file_path = dir .. '' .. target_file

    -- Check if the file exists in the current directory
    if vim.loop.fs_stat(file_path) then
      return file_path -- Return the full path if the file is found
    end

    -- Move up one directory level
    dir = dir:match '(.*/)[^/]+/$' or '/'
  end

  -- Return nil if the file is not found
  return nil
end

function run_test()
  local current_file = vim.api.nvim_buf_get_name(0)
  local directory = current_file:match '(.*/)'
  require('jester').run {
    cmd = "dotenv -e /home/qxz0myb/work/d3apps/.env -- ./node_modules/.bin/jest -t '$result' --config="
      .. find_file_in_parents(directory, 'jest.config.ts')
      .. ' -- $file', -- run command
    path_to_jest_run = './node_modules/.bin/jest', -- used to run test
  }
end

function run_file()
  local current_file = vim.api.nvim_buf_get_name(0)
  local directory = current_file:match '(.*/)'
  require('jester').run_file {
    cmd = 'dotenv -e /home/qxz0myb/work/d3apps/.env -- ./node_modules/.bin/jest --config=' .. find_file_in_parents(directory, 'jest.config.ts') .. ' -- $file', -- run command
    path_to_jest_run = './node_modules/.bin/jest', -- used to run test
  }
end

function debug_test()
  local current_file = vim.api.nvim_buf_get_name(0)
  local directory = current_file:match '(.*/)'
  require('jester').debug {
    path_to_jest_run = './node_modules/.bin/jest', -- used to run test
    path_to_jest_debug = './node_modules/.bin/jest',
    dap = { -- debug adapter configuration
      runtimeArgs = {
        '--env-file',
        '/home/qxz0myb/work/d3apps/.env',
        '--inspect-brk',
        '$path_to_jest',
        '--no-coverage',
        '-t',
        '$result',
        '--config',
        find_file_in_parents(directory, 'jest.config.ts'),
        '--',
        '$file',
      },
    },
  }
end
