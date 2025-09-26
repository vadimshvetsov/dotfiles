-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- SSH clipboard integration
if vim.env.SSH_TTY then
  vim.opt.clipboard = "unnamedplus"

  local function paste()
    return function()
      local content = vim.fn.getreg('"')
      return vim.split(content, '\n')
    end
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste(),
      ["*"] = paste(),
    },
  }
end
