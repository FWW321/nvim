local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- 将tab转换为空格
opt.expandtab = true
-- 将tab转换为空格时的空格数
opt.tabstop = 2
-- 在一行的开头敲下tab时插入的空格数
-- 换行时自动缩进的空格数
-- 如果为0则使用tabstop的值
opt.shiftwidth = 2
-- 自动缩进
opt.autoindent = true

-- 防止包裹(即超出一行时不换行显示)
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")

-- 默认新分割窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

-- 编码
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- 文件被外部程序修改时自动加载
opt.autoread = true

-- 禁用neovim自己的模式显示
opt.showmode = false
