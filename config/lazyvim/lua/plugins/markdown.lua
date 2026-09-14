return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- The plugin author runs it on defaults. His whole config is file_types,
    -- html off, and lsp completions. Everything that looks good in the repo
    -- demos is a default, and the demos themselves are `setup({})`.
    --
    -- The LazyVim markdown extra overrides three of those defaults. Setting
    -- them back to nil drops the override so the plugin default applies again,
    -- rather than pinning a copy of today's default value here.
    opts = function(_, opts)
      -- heading: extra sets `sign = false, icons = {}`. Treesitter still hides
      -- the '#' markers, so headings lose every level indicator. The defaults
      -- are circled numerals 1 to 6 plus a staircase indent per level.
      opts.heading = nil
      -- code: extra sets `sign = false, width = 'block', right_pad = 1`.
      opts.code = nil
      -- checkbox: extra sets `enabled = false`, so task lists stay raw '- [ ]'.
      opts.checkbox = nil

      -- The author's own three settings.
      opts.html = { enabled = false }
      opts.completions = { lsp = { enabled = true } }
      opts.file_types = { "markdown", "gitcommit" }

      -- One deviation from him, because our setups differ: the extra runs
      -- prettier on markdown, which pads every table cell out to the widest in
      -- its column. The default 'padded' keeps that padding, so tables render
      -- as wide as the file. 'trimmed' measures the content instead. He lints
      -- markdown with markdownlint only, so he never hits this.
      opts.pipe_table = { cell = "trimmed" }
    end,
  },
}
