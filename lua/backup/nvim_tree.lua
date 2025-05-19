return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
  end,
  opts = {
    sort = {
      sorter = "case_sensitive"
    },
    view = {
      width = 20
    },
    renderer = {
      group_empty = true
    },
    filters = {
      dotfiles = true
    }
  }
}
