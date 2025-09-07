return {
  -- add dracula
  {
    "Mofiqul/dracula.nvim",
    opts = {
      overrides = function(colors)
        return {
          -- SnacksDashboard
          SnacksDashboardHeader = { fg = colors.purple },
          SnacksDashboardKey = { fg = colors.orange },
          SnacksDashboardDesc = { fg = colors.cyan },
          SnacksDashboardIcon = { fg = colors.cyan },
          SnacksDashboardFooter = { fg = colors.purple, italic = true },

          -- SnacksPicker
          SnacksBackdrop = { link = "FloatShadow" },
          SnacksPickerBorder = { fg = colors.comment },
          SnacksPickerDir = { fg = colors.fg },
          SnacksPickerDirectory = { fg = colors.fg },
          SnacksPickerFile = { fg = colors.fg },
          SnacksPickerGitStatusIgnored = { fg = colors.comment },
          SnacksPickerGitStatusModified = { fg = colors.yellow },
          SnacksPickerGitStatusRenamed = { fg = colors.yellow },
          SnacksPickerGitStatusStaged = { fg = colors.bright_green },
          SnacksPickerGitStatusUnmerged = { fg = colors.orange },
          SnacksPickerGitStatusUntracked = { fg = colors.green },
          SnacksPickerInput = { link = "NormalFloat" },
          SnacksPickerInputBorder = { link = "SnacksPickerBorder" },
          SnacksPickerMatch = { fg = colors.green, italic = true },
          SnacksPickerPathHidden = { fg = colors.comment },
          SnacksPickerPrompt = { fg = colors.purple },
          SnacksPickerTitle = { fg = colors.cyan, bold = true },
        }
      end,
    },
  },

  -- Configure LazyVim to load dracula
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
