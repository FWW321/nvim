return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true }, -- 大文件优化
    dashboard = { enabled = true }, -- 启用仪表盘
    explorer = { enabled = true }, -- 文件浏览器增强
    indent = { enabled = true }, -- 缩进指南线
    input = { enabled = true }, -- 输入框增强
    picker = { enabled = true }, -- 选择器UI
    notifier = { enabled = true }, -- 通知系统
    quickfile = { enabled = true }, -- 快速文件操作
    scope = { enabled = true }, -- 代码作用域高亮
    scroll = { enabled = true }, -- 滚动优化
    statuscolumn = { enabled = true }, -- 状态列增强
    words = { enabled = true }, -- 单词操作增强
  },
}
