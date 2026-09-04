-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Clipboard over OSC 52. SSH_TTY is unset inside Herdr/tmux panes, so gate on
-- SSH_CONNECTION. Leave 'clipboard' empty: unnamedplus would route puts through
-- paste, which Herdr can't answer (herdrdev/herdr#3136).
local remote = vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.HERDR_ENV or vim.env.TMUX
if remote and not vim.env.DISPLAY and not vim.env.WAYLAND_DISPLAY then
  local osc52 = require("vim.ui.clipboard.osc52")

  local function paste()
    return vim.split(vim.fn.getreg('"'), "\n")
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }

  -- Mirror plain yanks into "+" so `y` reaches the host clipboard.
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      local ev = vim.v.event
      if ev.operator == "y" and (ev.regname == "" or ev.regname == '"') then
        vim.fn.setreg("+", ev.regcontents, ev.regtype)
      end
    end,
  })
end
