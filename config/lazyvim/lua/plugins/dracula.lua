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
          SnacksDashboardDesc = { fg = colors.fg },
          SnacksDashboardIcon = { fg = colors.purple },
          SnacksDashboardTitle = { fg = colors.pink },
          SnacksDashboardFooter = { fg = colors.comment },
          -- SnacksPicker
          SnacksNormal = { link = "NormalFloat" },
          SnacksWinBar = { link = "Title" },
          SnacksBackdrop = { link = "FloatShadow" },
          SnacksNormalNC = { link = "NormalFloat" },
          SnacksWinBarNC = { link = "SnacksWinBar" },
          SnacksPickerInputBorder = { fg = colors.purple },
          SnacksPickerInputTitle = { fg = colors.purple },
          SnacksPickerLabel = { fg = colors.orange },
          SnacksPickerDir = { fg = colors.fg },
          SnacksPickerDirectory = { fg = colors.fg },
          SnacksPickerFile = { fg = colors.fg },
          SnacksPickerIcon = { fg = colors.orange, bg = colors.orange },
          SnacksPickerIconSource = { fg = colors.orange, bg = colors.orange },
          SnacksPickerIconName = { fg = colors.orange, bg = colors.orange },
          SnacksPickerIconCategory = { fg = colors.orange, bg = colors.orange },
          SnacksPickerGitStatusRenamed = { fg = colors.bright_magenta },
          SnacksPickerGitStatusModified = { fg = colors.bright_magenta },
          SnacksPickerGitStatusUntracked = { fg = colors.bright_green },
          SnacksPickerPathHidden = { fg = colors.comment },
          SnacksPickerPathIgnored = { fg = colors.comment },
          SnacksPickerIconFile = { fg = colors.purple },
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
