require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        preview_cutoff = 0,
        preview_position = "top",
        prompt_position = "bottom",
        width = 0.9,
        height = 0.9,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help for commands" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
