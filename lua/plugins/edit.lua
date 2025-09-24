return {
	{
		-- 自动闭合括号，引号等
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			-- will ignore alphanumeric and `.` symbols
			ignored_next_char = "[%w%.]",
		},
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo-tree" },
		},
		init = function()
			vim.cmd([[
      if has("persistent_undo")
         let target_path = expand('~/.undodir')

          " create the directory and any parent directories if the location does not exist.
          if !isdirectory(target_path)
              call mkdir(target_path, "p", 0700)
          endif

          let &undodir=target_path
          set undofile
      endif
      ]])
		end,
	},
	{
		-- 将复制的内容放到系统剪贴板
		"ibhagwan/smartyank.nvim",
		event = { "BufWinEnter" },
		opts = {
			highlight = {
				timeout = 500, -- timeout for clearing the highlight
			},
			clipboard = {
				enabled = true,
			},
			osc52 = {
				silent = true, -- true to disable the "n chars copied" echo
			},
		},
	},
	{
		-- 光标快速跳转
		"folke/flash.nvim",
		event = "BufReadPost",
		opts = {
			label = {
				rainbow = {
					enabled = true,
					shade = 1,
				},
			},
			modes = {
				char = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"<leader>fj",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "[Flash] Jump",
			},
			{
				"<leader>ft",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "[Flash] Treesitter",
			},
			{
				"<leader>fs",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "[Flash] Treesitter Search",
			},
			-- 对常规搜索启用闪搜的开关
			{
				"<c-f>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "[Flash] Toggle Search",
			},
			-- 跳转到行首（包括空行）
			{
				"<leader>fl",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						search = { mode = "search", max_length = 0 },
						label = { after = { 0, 0 }, matches = false },
						jump = { pos = "end" },
						pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
					})
				end,
				desc = "[Flash] Line jump",
			},
			-- 跳转到非空行的行尾
			{
				"<leader>fe",
				mode = { "n", "x", "o" }, -- 支持 Normal/Visual/Operator-pending 模式
				function()
					require("flash").jump({
						search = {
							mode = "search", -- 使用正则搜索
							max_length = 0, -- 不限制匹配长度
						},
						pattern = [[\S\zs.*$]], -- 匹配非空行的行尾（\S 为非空白字符，\zs 重置匹配起点）
						label = {
							after = { 0, 0 }, -- 标签显示在匹配项后
							matches = false, -- 不显示所有匹配项的标签
						},
						jump = {
							pos = "end", -- 跳转到匹配项的结尾
						},
					})
				end,
				desc = "[Flash] Jump to line end (non-empty)",
			},
		},
	},
	{
		-- 注释
		-- 输入:Neogen会自动检测当前光标所在代码上下文（如函数、类）等，生成相应注释
		-- 输入:Neogen <类型(func|class|type|file)>,会找到最近的相应类型生成注释
		"danymat/neogen",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>nf",
				mode = { "n" },
				function()
					require("neogen").generate({ type = "func" })
				end,
				desc = "[neogen] 生成函数注释",
			},
			{
				"<leader>nc",
				mode = { "n" },
				function()
					require("neogen").generate({ type = "class" })
				end,
				desc = "[neogen] 生成类注释",
			},
		},
		config = true,
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
	-- 需要安装ripgrep
	{
		-- 注释 TODO, FIX等高亮显示
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/snacks.nvim",
		},
		enabled = true,
		event = "VeryLazy",
		opts = {
			highlight = {
				multiline = false, -- 是否高亮多行注释中的关键词
				-- vim正则表达式，用来高亮，KEYWORDS会被替换为实际的关键词列表
				pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
			},
			search = {
				-- 用于ripgrep的正则，用来搜索
				pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
			},
		},
		keys = {
			{
				"<leader>st",
				mode = { "n" },
				function()
					Snacks.picker.todo_comments({
						keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "HACK", "WARN", "ISSUE" },
					})
				end,
				desc = "[TODO] Pick todos (without NOTE)",
			},
			{
				"<leader>sT",
				mode = { "n" },
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "[TODO] Pick todos (with NOTE)",
			},
		},
	},

	{
		-- 删除或替换包围的括号、引号等，可视模式下可以添加
		"echasnovski/mini.surround",
		version = "*",
		event = "BufReadPost",
		config = true,
		-- keys = {
		-- 	-- Disable the vanilla `s` keybinding
		-- 	-- 禁用了vim的s键绑定，即删除字符并进入插入模式的功能
		-- 	{ "s", "<NOP>", mode = { "n", "x", "o" } },
		-- },
		mappings = {
			add = "sa",
			delete = "sd",
			find = "sf",
			find_left = "sF",
			highlight = "sh",
			replace = "sr",
			update_n_lines = "sn",

			suffix_last = "l",
			suffix_next = "n",
		},
	},

	{
		-- 拓展a/i文本对象
		"echasnovski/mini.ai",
		version = "*",
		event = "BufReadPost",
		config = true,
	},

	{
		"echasnovski/mini.comment",
		version = "*",
		event = "VeryLazy",
		opts = {
			-- 计算自定义注释符号的函数（可选）
			custom_commentstring = nil,
			-- 注释时是否忽略空行
			ignore_blank_line = false,
			-- 在操作和文本对象中是否忽略空行
			start_of_line = false,
			-- 是否强制在注释部分使用单空格内边距
			pad_comment_parts = true,
		},
		-- 模块按键映射时，使用''（空字符串）可禁用某个映射
		mappings = {
			-- 切换注释（如`gcip`-注释段落），适用于普通模式和可视模式
			comment = "gc", -- NOTE: 只是一个操作，需要跟上移动
			-- 切换当前行的注释
			comment_line = "gcc",
			-- 切换可视选中内容的注释
			comment_visual = "gc",
			-- 定义注释文本对象（如`dgc` - 删除整个注释块）
			-- 如果映射与`comment_visual`不同，在可视模式下同样生效
			textobject = "gc",
		},
	},

	{
		-- 多光标编辑
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		event = "BufReadPost",
		keys = {
			-- Append/insert for each line of visual selections. Similar to block selection insertion.
			{
				"mI",
				function()
					require("multicursor-nvim").insertVisual()
				end,
				mode = "x",
				desc = "Insert cursors at visual selection",
			},
			{
				"mA",
				function()
					require("multicursor-nvim").appendVisual()
				end,
				mode = "x",
				desc = "Append cursors at visual selection",
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- Mappings defined in a keymap layer only apply when there are multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					mc.clearCursors()
				end)
			end)
		end,
	},
}
