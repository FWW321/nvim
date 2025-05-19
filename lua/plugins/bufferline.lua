return {
  'akinsho/bufferline.nvim', 
  version = "*", 
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
  },
  config = function()
    require("bufferline").setup{}

    vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")
    vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")
  end
}
