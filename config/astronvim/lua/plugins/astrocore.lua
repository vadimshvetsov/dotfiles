-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        clipboard = "", -- sets vim.opt.clipboard to empty
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        -- text replace
        ["<Leader>r"] = {
          ":%s///g<Left><Left>",
          desc = "Find and replace",
        },
        -- open homescreen when last buffer closed
        ["<Leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = 1 }
            require("astrocore.buffer").close(0)
            if require("astrocore").is_available "alpha-nvim" and not bufs[2] then require("alpha").start() end
          end,
          desc = "Close buffer",
        },
        ["<Leader><cr>"] = {
          ":so %<cr>",
          desc = "Source current file",
        },
        -- clipboard
        ["<Leader>y"] = { '"+y', desc = "Yank to system clipboard" },
        ["<Leader>p"] = { '"+p', desc = "Paste from system clipboard" },
        ["<Leader>Y"] = { '"+Y', desc = "Yank line to system clipboard" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
      v = {
        ["<Leader>r"] = {
          ":s/",
          desc = "Find and replace",
        },
        -- clipboard
        ["<Leader>y"] = { '"+y', desc = "Yank selection to system clipboard" },
        ["<Leader>p"] = { '"+p', desc = "Paste from system clipboard" },
      },
    },
  },
}
