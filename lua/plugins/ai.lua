-- 需要安装nodejs
-- 执行:Copilot auth登录
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "VeryLazy",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	{
		-- 输入:CodeCompanionChat打开对话框,Insert模式<C-s>,Normal模式<CR>提交对话
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.diff",
			"j-hui/fidget.nvim",
		},

		init = function()
			require("utils.codecompanion_fidget_spinner"):init()
		end,

		keys = {
			{
				-- 打开行为选项窗口
				"<leader>cca",
				"<CMD>CodeCompanionActions<CR>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion actions",
			},
			{
				-- 行内询问，以diff的形式显示，ga接受，gr拒绝
				"<leader>cci",
				"<CMD>CodeCompanion<CR>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion inline",
			},
			{
				"<leader>ccc",
				"<CMD>CodeCompanionChat Toggle<CR>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion chat (toggle)",
			},
			{
				"<leader>ccp",
				"<CMD>CodeCompanionChat Add<CR>",
				mode = { "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion chat add code",
			},
		},

		opts = {
			display = {
				diff = {
					enabled = true,
					provider = "mini_diff",
				},
			},

			strategies = {
				chat = { adapter = "copilot" },
				inline = { adapter = "copilot" },
			},

			opts = {
				language = "Chinese", -- "English"|"Chinese"
			},
		},
	},
}
