-- 输入:ConformInfo调出控制面板，可以在Mason中下载格式化工具或者自己手动下载
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})

		-- 设置快捷键
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Format file" })
	end,
}
