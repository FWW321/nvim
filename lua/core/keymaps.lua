vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap

-- 插入模式
keymap.set("i", "jk", "<ESC>")
keymap.set("i", "<C-h>", "<Left>")
keymap.set("i", "<C-l>", "<Right>")
keymap.set("i", "<C-j>", "<Down>")
keymap.set("i", "<C-k>", "<Up>")

-- 可视模式
-- 单行或多行移动
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '>-2<CR>gv=gv")
-- 普通模式
-- 窗口
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-l>", "<C-w>l")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口
keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口
-- 取消高亮
-- keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set({ "n", "x", "o" }, "<S-H>", "^", { desc = "Start of line" })
keymap.set({ "n", "x", "o" }, "<S-L>", "$", { desc = "End of line" })
keymap.set({ "n", "x" }, "Q", "<CMD>:qa<CR>")
keymap.set({ "n", "x" }, "qq", "<CMD>:q<CR>")
-- keymap.set("n", "<A-z>", "<CMD>set wrap!<CR>", { desc = "Toggle line wrap" })
