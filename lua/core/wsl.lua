-- clip是windows的system32下的一个可执行程序
-- wsl可以使得linux子系统可以访问windows的文件系统和程序
-- 因此可以直接在vim的命令模式下将选取内容以管道的方式传递给clip.exe
-- 注意：clip不支持非英文字符
-- local sync_to_windows_clipboard = function()
-- 	vim.fn.system("clip.exe", vim.fn.getreg('"'))
-- end

-- 设置自动命令：在任何复制操作后自动同步
-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	pattern = "*",
-- 	callback = sync_to_windows_clipboard,
-- 	desc = "Sync yanked text to Windows clipboard",
-- })

-- win32yank是一个第三方工具，是clip更好的替代品，支持非英文字符
-- 可以通过paru -S win32yank-bin安装
-- 注意是在linux子系统中安装
-- 安装后的命令是win32yank.exe而不是win32yank
vim.g.clipboard = {
	name = "win32yank-wsl",
	copy = {
		["+"] = "win32yank.exe -i --crlf",
		["*"] = "win32yank.exe -i --crlf",
	},
	paste = {
		["+"] = "win32yank.exe -o --lf",
		["*"] = "win32yank.exe -o --lf",
	},
	cache_enabled = 0,
}
