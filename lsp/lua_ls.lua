return {
	-- lsp的可执行程序或命令
	-- 可以通过mason插件安装和管理
	cmd = { "lua-language-server" },
	-- 所使用的文件类型，不指定会在所有文件类型下启动
	filetypes = { "lua" },
	-- 通过特定文件或目录定位项目根目录
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
}
