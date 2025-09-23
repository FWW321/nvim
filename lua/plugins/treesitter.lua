-- 需要通过包管理器安装tree-sitter-cli，否则安装parser的时候会卡住不动
return {
	-- 把代码内容解析为抽象语法树(abstract syntax tree, AST)
	"nvim-treesitter/nvim-treesitter", -- 此插件不支持延迟加载
	lazy = false,
	-- build是插件安装完成之后会执行的命令
	build = ":TSUpdate",
	-- master分支停止更新，使用main分支
	-- 必须显式指定，因为默认是master
	branch = "main",
	-- config是插件加载完成之后会执行的配置函数
	config = function()
		local nvim_treesitter = require("nvim-treesitter")
		nvim_treesitter.setup()

		-- 需要确保安装的解析器（parser）列表
		local ensure_installed = { "rust", "sql", "yaml", "bash", "python", "toml", "lua" }
		local pattern = {}
		-- ipairs会按照index, value的方式遍历
		for _, parser in ipairs(ensure_installed) do
			-- vim.treesitter内置一些parser,所以:checkhealth nvim-treesitter不会显示
			-- pcall是lua的错误捕获函数，用于安全地执行可能会出错的代码
			-- 如果调用的函数发生错误，pcall会捕获错误并返回false，而不是让整个程序崩溃
			-- vim.treesitter.language.inspect是neovim内置的tree-sitter函数
			-- 用于获取指定语言的解析器元信息
			-- vim.treesitter.language.inspect("语言名")
			local has_parser, _ = pcall(vim.treesitter.language.inspect, parser)

			if not has_parser then
				-- 新版本不会自动安装缺失的parser
				-- 需要用户自行安装
				-- 可以通过命令 :TSInstall <language> 来安装指定语言的parser
				-- install是新版本的api，用于安装指定语言的解析器
				-- 如果解析器已经安装，则不会执行任何操作，这个函数是异步运行的
				-- require("nvim-treesitter.config").get_install_dir() 获取当前解析器的安装目录
				-- 如果高亮失败，可以删除该目录，重新安装
				-- nvim_treesitter.install(parser)
				-- 使用wait()等待其完成,最多等待5分钟
				nvim_treesitter.install(parser):wait(300000)
			end

			-- vim.tbl_extend 是一个用于合并多个表的函数
			-- keep模式保留最早出现的键值，忽略后续表的同名键
			-- vim.treesitter.language.get_filetypes(parser) 获取与指定语言解析器关联的文件类型
			pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
		end
		-- 自动命令，当打开指定文件类型时，执行对应命令
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("nvim-treesitter", {}),
			pattern = pattern,
			callback = function()
				-- 新版本不再自动应用高亮，需要手动为缓冲区调用vim.treesitter.start()
				vim.treesitter.start()
				-- 新版本移除了setup中的indent选项
				-- 改为手动设置indentexpr
				-- vim.bo用于设置缓冲区局部选项，仅对当前缓冲区生效
				-- indentexpr是neovim用于计算缩进的表达式
				-- v:lua是neovim的vimscript调用lua函数的接口
				-- require'nvim-treesitter'.indentexpr()调用nvim-treesitter提供的缩进计算函数
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				-- 基于tree-sitter语法树实现代码折叠
				-- vim.wo用于设置窗口局部选项，仅对当前窗口生效
				-- 使用lsp的代码折叠
				-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end,
		})
	end,
}
