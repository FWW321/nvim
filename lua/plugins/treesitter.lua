return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { 
      "vim", 
      "bash", 
      "c", 
      "cpp", 
      "javascript", 
      "json", 
      "lua", 
      "python",
      "markdown",
      "rust",
      "java",
      "zig",
      "go",
      "toml",
      "xml",
      "yaml",
      "ruby",
      "c_sharp",
      "cmake",
      "typescript",
      "sql",
      "html",
      "css",
    },
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
  }
}
