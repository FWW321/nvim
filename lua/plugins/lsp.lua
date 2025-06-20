return {
	{
		-- 命令行输入":Mason"启动Mason的控制面板
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			-- 自动检查ensure_installed的lsp是否下载，如果没有则下载
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			vim.diagnostic.config({
				underline = false,
				signs = false,
				update_in_insert = false,
				virtual_text = { spacing = 2, prefix = "●" },
				severity_sort = true,
				float = {
					border = "rounded",
				},
			})
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig["lua_ls"].setup({ capabilities = capabilities })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- 显示悬停文档
					vim.keymap.set("n", "K", vim.lsp.buf.hover)
					-- 打开浮动诊断窗口
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
						buffer = ev.buf,
						desc = "[LSP] Show diagnostic",
					})
					-- 显示函数签名帮助
					vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] signature help" })
					-- 工作区文件夹(Workspace Folder)是指LSP服务器将进行代码分析、提供智能功能的根目录
					-- 添加工作区文件夹
					vim.keymap.set(
						"n",
						"<leader>wa",
						vim.lsp.buf.add_workspace_folder,
						{ desc = "[LSP] Add wordspace folder" }
					)
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
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })
				end,
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
