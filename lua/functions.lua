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

-- ~/.config/nvim/ftplugin/java.lua
function SearchFileBackwards(fn)
  local fp = vim.fn.expand '%:p'
  local pos = #fp
  local pom = ''
  while pos > 0 do
    if fp:sub(pos, pos) == '/' then
      pom = fp:sub(1, pos) .. fn
      if vim.fn.filereadable(pom) == 1 then
        break
      end
    end
    pos = pos - 1
  end
  return pom
end

function BuildMavenProject()
  local pom = SearchFileBackwards 'pom.xml'
  if pom ~= '' then
    vim.fn.system('mvn -f ' .. pom .. ' compile')
  else
    vim.api.nvim_echo({ { 'No pom.xml found.', 'WarningMsg' } }, true, {})
  end
end
