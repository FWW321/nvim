-- nvim 0.11版本可以不用安装nvim-lspconfig插件，直接使用内置的lsp功能
-- nvim会在根配置文件夹下寻找lsp文件夹查找lsp配置
-- :checkhealth vim.lsp可以查看lsp的情况
-- nvim 0.11会自动配置capabilities
-- lsp目录下的文件可以随便命名，但为了兼容性和可读性，建议参考lspconfig的命名方式
-- 可以参考lspconfig仓库下的lsp目录下的lsp配置文件进行配置
vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("taplo")

-- LSP成功附加到缓冲区时触发
-- 将自动命令分组，防止重复定义
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", {}),
	callback = function(event)
		-- 获取LSP客户端
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				prefix = "●",
			},
			float = {
				severity_sort = true,
			},
			serverity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
		})
		-- 跳转到定义 goto definition
		-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "[LSP] Go to definition" })
		-- 跳转到声明 goto declaration
		-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "[LSP] Go to declaration" })
		-- 显示悬停文档
		vim.keymap.set("n", "K", vim.lsp.buf.hover)
		-- 打开浮动诊断窗口
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
			buffer = event.buf,
			desc = "[LSP] Show diagnostic",
		})
		-- 显示函数签名帮助
		vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] signature help" })
		-- 工作区文件夹(Workspace Folder)是指LSP服务器将进行代码分析、提供智能功能的根目录
		-- 添加工作区文件夹
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[LSP] Add wordspace folder" })
		-- 移除工作区文件夹
		vim.keymap.set(
			"n",
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ desc = "[LSP] Remove workspace folder" }
		)
		-- 列出工作区文件夹
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { desc = "[LSP] List workspace folders" })
		-- 重命名符号
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "[LSP] Rename" })
		-- lsp代码折叠，比treesitter的折叠效果更好，但是需要lsp支持
		if client and client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
		-- 内联提示（inlay hint）
		-- 需要lsp支持
		-- 显示函数参数和变量类型等信息
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, { buffer = event.buf, desc = "[LSP] Toggle inlay hints" })
		end
		-- autocmd中的autocmd
		-- 在光标停留时高亮当前符号的所有引用
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_group,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_group,
				callback = vim.lsp.buf.clear_references,
			})
			-- LSP客户端断开连接时清除符号引用和高亮
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ buffer = event2.buf, group = "lsp-highlight" })
				end,
			})
		end
	end,
})
