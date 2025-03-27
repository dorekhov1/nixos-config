-- Create this file as 'neotest-debug.lua' and source it with :luafile neotest-debug.lua

local M = {}

-- Function to print detailed information about the environment
function M.debug_environment()
  local output = {
    "=== NeoTest Debug Information ===",
    "Current directory: " .. vim.fn.getcwd(),
    "Python version: " .. vim.fn.system("python --version"):gsub("\n", ""),
    "Pytest version: " .. vim.fn.system("python -m pytest --version"):gsub("\n", ""),
  }

  -- Check for pyproject.toml
  local pyproject_path = vim.fn.getcwd() .. "/pyproject.toml"
  if vim.fn.filereadable(pyproject_path) == 1 then
    table.insert(output, "pyproject.toml found at: " .. pyproject_path)
    local content = vim.fn.readfile(pyproject_path)
    local testpaths = ""
    for _, line in ipairs(content) do
      if line:match("testpaths") then
        testpaths = line
        break
      end
    end
    if testpaths ~= "" then
      table.insert(output, "Test paths config: " .. testpaths)
    end
  else
    table.insert(output, "WARNING: No pyproject.toml found!")
  end

  -- Check for pytest.ini
  local pytest_ini_path = vim.fn.getcwd() .. "/pytest.ini"
  if vim.fn.filereadable(pytest_ini_path) == 1 then
    table.insert(output, "pytest.ini found at: " .. pytest_ini_path)
  end

  -- Check for tests directory
  local tests_dir = vim.fn.getcwd() .. "/tests"
  if vim.fn.isdirectory(tests_dir) == 1 then
    table.insert(output, "Tests directory found: " .. tests_dir)
    local files = vim.fn.glob(tests_dir .. "/**/*.py", false, true)
    table.insert(output, string.format("Found %d Python files in tests directory", #files))
    if #files > 0 then
      table.insert(output, "Sample test files:")
      for i = 1, math.min(5, #files) do
        table.insert(output, "  " .. files[i]:sub(#vim.fn.getcwd() + 2))
      end
    end
  else
    table.insert(output, "WARNING: No tests directory found!")
  end

  return output
end

-- Function to try running a test file directly with pytest
function M.run_test_directly(file_path)
  local file = file_path or vim.fn.expand("%")
  local cmd = string.format("cd %s && python -m pytest %s -v", vim.fn.getcwd(), file)

  print("Running test directly: " .. cmd)

  -- Create a temporary file to capture output
  local temp_file = vim.fn.tempname()
  local full_cmd = cmd .. " > " .. temp_file .. " 2>&1"

  -- Run the command
  vim.fn.system(full_cmd)

  -- Read and display the output
  local output = vim.fn.readfile(temp_file)

  -- Create a new split to show the results
  vim.cmd("vsplit " .. temp_file)

  return output
end

-- Function to check if a path contains test files according to neotest
function M.check_test_path(path)
  -- Get the neotest python adapter
  local neotest = require("neotest")
  local adapter = neotest.state.adapter_ids()[1]

  if not adapter then
    return { "No neotest adapter found!" }
  end

  -- Execute the actual python command to discover tests
  local adapter_obj = neotest.get_adapters()[1]
  if not adapter_obj then
    return { "Failed to get adapter object" }
  end

  -- Check if the file is a test file according to the adapter
  local output = { "=== Test File Detection ===" }
  local test_files = {}

  -- If path is a directory, check all Python files in it
  if vim.fn.isdirectory(path) == 1 then
    local files = vim.fn.glob(path .. "/**/*.py", false, true)
    table.insert(output, string.format("Found %d Python files in path", #files))

    for _, file in ipairs(files) do
      local is_test = adapter_obj.is_test_file(file)
      if is_test then
        table.insert(test_files, file)
        table.insert(output, string.format("✓ %s - IS a test file", file:sub(#vim.fn.getcwd() + 2)))
      else
        table.insert(output, string.format("✗ %s - NOT a test file", file:sub(#vim.fn.getcwd() + 2)))
      end
    end
  else
    -- Single file
    local is_test = adapter_obj.is_test_file(path)
    if is_test then
      table.insert(test_files, path)
      table.insert(output, string.format("✓ %s - IS a test file", path:sub(#vim.fn.getcwd() + 2)))
    else
      table.insert(output, string.format("✗ %s - NOT a test file", path:sub(#vim.fn.getcwd() + 2)))
    end
  end

  table.insert(output, string.format("\nFound %d test files", #test_files))
  return output
end

-- Create a user command to run the diagnostic tool
vim.api.nvim_create_user_command("NeotestDiagnose", function()
  local env_info = M.debug_environment()

  -- Create a floating window to display the output
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, env_info)

  local width = 100
  local height = #env_info + 2
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = 1,
    col = 1,
    style = "minimal",
    border = "rounded",
  })

  -- Check if there are test files in the test directory
  local test_files_info = M.check_test_path(vim.fn.getcwd() .. "/tests")
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "" })
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, test_files_info)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
end, {})

-- Create a command to run a test file directly with pytest
vim.api.nvim_create_user_command("NeotestRunDirect", function(opts)
  local file = opts.args ~= "" and opts.args or vim.fn.expand("%")
  M.run_test_directly(file)
end, { nargs = "?", complete = "file" })

-- Return the module
return M
