return {
  -- add dracula
  {
    "Mofiqul/dracula.nvim",
    opts = {
      overrides = function(colors)
        -- Mix `fg` into the background. 0.15 gives a dark tint of the color.
        local function blend(fg, alpha)
          local function rgb(hex)
            hex = hex:gsub("#", "")
            return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
          end
          local fr, fg_, fb = rgb(fg)
          local br, bg_, bb = rgb(colors.bg)
          local function mix(a, b)
            return math.floor(a * alpha + b * (1 - alpha) + 0.5)
          end
          return string.format("#%02x%02x%02x", mix(fr, br), mix(fg_, bg_), mix(fb, bb))
        end

        -- render-markdown links heading backgrounds to Diff* groups. Dracula
        -- makes DiffAdd solid green and gives the others no background, so H2
        -- is a loud green bar and every other level has no bar at all.
        local heading = { colors.purple, colors.pink, colors.cyan, colors.green, colors.orange, colors.yellow }
        local md = {}
        for i, c in ipairs(heading) do
          md["RenderMarkdownH" .. i] = { fg = c, bold = true }
          md["RenderMarkdownH" .. i .. "Bg"] = { fg = c, bg = blend(c, 0.15), bold = true }
        end

        return vim.tbl_extend("force", md, {
          -- Lua Line
          StatusLine = { bg = colors.selection },
          StatusLineTerm = { bg = colors.selection },

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
          SnacksPickerPathIgnored = { fg = colors.comment },
          SnacksPickerPathHidden = { fg = colors.comment },
          SnacksPickerPrompt = { fg = colors.purple },
          SnacksPickerTitle = { fg = colors.cyan, bold = true },
        })
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
