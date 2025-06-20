return {
  "nvim-treesitter/nvim-treesitter",
  -- build是插件安装完成之后会执行的命令
  build = ":TSUpdate",
  opts = {
    -- 如果打开一个没有安装treesitter的文件，会自动找到对应的treesitter安装
    auto_install = true,
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
