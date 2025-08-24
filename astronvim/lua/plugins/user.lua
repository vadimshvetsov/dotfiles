-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            "██████   █████  ██████  ████████ ██   ██",
            "██   ██ ██   ██ ██   ██    ██    ██   ██",
            "██   ██ ███████ ██████     ██    ███████",
            "██   ██ ██   ██ ██   ██    ██    ██   ██",
            "██████  ██   ██ ██   ██    ██    ██   ██",
            " ",
            " ███    ██ ██    ██ ██ ███    ███",
            " ████   ██ ██    ██ ██ ████  ████",
            " ██ ██  ██ ██    ██ ██ ██ ████ ██",
            " ██  ██ ██  ██  ██  ██ ██  ██  ██",
            " ██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },
}
