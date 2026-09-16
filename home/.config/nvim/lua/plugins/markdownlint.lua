return {
  {
    "mfussenegger/nvim-lint",
    opts = function()
      -- markdownlint fires on nearly every prose paragraph, mostly line-length.
      -- Its message renders as virtual text glued after the end of the line, and
      -- a markdown paragraph is one long line that soft-wraps, so there is no
      -- room left. The message spills across the wrapped rows and leaves one or
      -- two character scraps down the right edge of the window.
      --
      -- nvim-lint gives each linter its own diagnostic namespace for exactly
      -- this, so scope the change to that namespace instead of the global
      -- config. marksman and every other source keep their virtual text, here
      -- and everywhere else.
      --
      -- Signs, underline, <leader>cd and Trouble still show these warnings.
      local ns = require("lint").get_namespace("markdownlint-cli2")
      vim.diagnostic.config({ virtual_text = false }, ns)
    end,
  },
}
