return {
  "mfussenegger/nvim-lint",
  optional = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Define custom vulture linter
    lint.linters.vulture = {
      cmd = "vulture",
      stdin = false,
      args = {
        function()
          -- Find project root
          local git_root_or_err = vim.fn.system("git rev-parse --show-toplevel"):sub(1, -2)
          local project_root = vim.startswith(git_root_or_err, "fatal") and vim.fn.getcwd() or git_root_or_err

          -- Attempt to find and extract package name from pyproject.toml
          local pyproject_path = project_root .. "/pyproject.toml"
          local package_name = nil

          -- Check if pyproject.toml exists
          if vim.fn.filereadable(pyproject_path) == 1 then
            -- Read the file content
            local content = vim.fn.readfile(pyproject_path)
            local content_str = table.concat(content, "\n")

            -- Try to extract package name using pattern matching
            package_name = content_str:match('packages%s*=%s*%[%s*{%s*include%s*=%s*"([^"]+)"')
              or content_str:match("packages%s*=%s*%[%s*{%s*include%s*=%s*'([^']+)'")

            -- Fall back to src directory if present
            if not package_name and vim.fn.isdirectory(project_root .. "/src") == 1 then
              package_name = "src"
            end
          end

          -- Return the vulture path (package or project root)
          if package_name then
            return project_root .. "/" .. package_name
          else
            return project_root
          end
        end,
      },
      ignore_exitcode = true,
      append_fname = false,
      parser = require("lint.parser").from_pattern(
        "([^:]+):(%d+): (.*)", -- pattern
        { "file", "lnum", "message" }, -- groups
        nil,
        {
          ["source"] = "vulture",
          ["severity"] = vim.diagnostic.severity.WARN,
        }
      ),
    }

    -- Register linters by filetype
    lint.linters_by_ft = {
      python = { "ruff", "vulture" },
    }

    -- Create a command to manually trigger linting
    vim.api.nvim_create_user_command("VultureLint", function()
      lint.try_lint("vulture")
    end, {})

    -- Setup autocommand for linting
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
      pattern = "*.py",
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
