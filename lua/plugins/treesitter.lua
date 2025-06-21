return {
	-- 把代码内容解析为抽象语法树(abstract syntax tree, AST)
	"nvim-treesitter/nvim-treesitter", -- 此插件不支持延迟加载
	lazy = false,
	-- build是插件安装完成之后会执行的命令
	build = ":TSUpdate",
	-- master分支停止更新，使用main分支
	branch = "main",
	config = function()
		local nvim_treesitter = require("nvim-treesitter")
		nvim_treesitter.setup()

		local ensure_installed = { "rust", "sql", "yaml", "bash", "python", "toml", "lua" }
		local pattern = {}
		for _, parser in ipairs(ensure_installed) do
			-- neovim 自己的 api，找不到这个 parser 会报错
			-- vim.treesitter内置一些parser,所以:checkhealth nvim-treesitter不会显示
			-- 因为has_parser对内置的parser会返回true,nvim-treesitter不会install
			local has_parser, _ = pcall(vim.treesitter.language.inspect, parser)

			if not has_parser then
				-- install 是 nvim-treesitter 的新 api，默认情况下无论是否安装 parser 都会执行，所以这里我们做一个判断
				nvim_treesitter.install(parser)
				-- else
				-- 新版本需要手动启动高亮，但没有安装相应 parser会导致报错
				-- pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
			end
			-- 新版本需要手动启动高亮，但没有安装相应 parser会导致报错
			pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
		end
		vim.api.nvim_create_autocmd("FileType", {
			pattern = pattern,
			callback = function()
				vim.treesitter.start()
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
