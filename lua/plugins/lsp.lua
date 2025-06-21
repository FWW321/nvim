return {
	{
		-- 命令行输入":Mason"启动Mason的控制面板
		"mason-org/mason.nvim",
		-- 懒加载插件
		-- event: 在某个事件触发时加载插件
		-- verLazy: lazy提供的特殊事件，可以理解为在启动阶段所有事件触发完毕之后才触发
		-- cmd: 在某个命令被执行时加载插件
		-- ft: filetype, 当前buffer为特定文件类型时加载插件
		-- keys: 当触发快捷键时加载插件，如果快捷键不存在则创建快捷键e
		-- lazy = false: 不懒加载，启动nvim时就加载插件

		-- 定义了opts后，如果没有定义config，则会自动调用require("mason").setup(opts)
		-- 相当于
		-- config = function(_, opts)
		--   -- 导入mason模块
		--   require("mason").setup(opts)
		-- end
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
			},
		},
		-- 如果定义了config,则会自动将opts传入config(_, opts)中
		-- 大多数时候我们不需要手动编写 config，除非需要在默认的加载以外做一些别的操作
		-- 由于覆盖了默认的config，所以需要手动调用require("mason").setup(opts)
		-- lazy会先执行插件lua文件，将所有插件返回的table放入到一个更大的table中，然后根据条件加载
		-- 所以lazy执行完插件lua文件后，只是将插件table放入到一个更大的table中，并没有真正加载插件
		-- config函数会在插件被加载时执行
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
		-- 输入:LspInfo查看当前LSP服务器状态
		-- Mason负责下载Lsp服务器，nvim-lspconfig负责配置LSP服务器
		-- Mason中的Lsp名称与nvim-lspconfig中的Lsp名称不一定相同
		-- 比如Mason中的lua-language-server对应nvim-lspconfig中的lua_ls
		-- mason-lspconfig插件存储了Mason中Lsp与nvim-lspconfig中Lsp的对应关系
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp", "mason-org/mason.nvim" },
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

			-- lsp 协议制定了一份规范，但是语言服务器和编辑器本身都不一定支持全部的特性
			-- 所以和 lsp 建立连接的时候，编辑器需要告诉服务器自己支持什么功能，即capabilities
			-- 为什么要手动设置capabilities？
			-- 1.部分lsp不配置可能会出问题
			-- 2.可以让lsp少返回一些内容，降低延迟
			-- 3.获得一些有用的功能

			-- 获取blink.cmp提供的lsp能力
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 设置lsp的capabilities
			-- local lspconfig = require("lspconfig")
			-- lspconfig["lua_ls"].setup({ capabilities = capabilities })
			vim.lsp.config("lua_ls", { capabilities = capabilities })

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

	{
		-- 输入:ConformInfo调出控制面板，可以在Mason中下载formatter或者自己手动下载
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "trim_whitespace" },
			},

			format_on_save = function(_)
				-- Disable with a global or buffer-local variable
				if vim.g.enable_autoformat then
					return { timeout_ms = 500, lsp_format = "fallback" }
				end
			end,
		},
		init = function()
			vim.g.enable_autoformat = true
			require("snacks").toggle
				.new({
					id = "auto_format",
					name = "Auto format",
					get = function()
						return vim.g.enable_autoformat
					end,
					set = function(state)
						vim.g.enable_autoformat = state
					end,
				})
				:map("<leader>tf")
		end,
	},
	{
		-- 许多lsp都带有lint功能,所以有时候不需要额外的lint插件
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()

					-- You can call `try_lint` with a linter name or a list of names to always
					-- run specific linters, independent of the `linters_by_ft` configuration
					-- codespell检查单词拼写，可以在Mason中下载
					require("lint").try_lint("codespell")
				end,
			})
		end,
	},

	{
		-- 查看诊断信息、symbols（符号）等
		"folke/trouble.nvim",
		cmd = "Trouble",
    -- stylua: ignore
    keys = {
      { "<A-j>", function() vim.diagnostic.jump({ count = 1 }) end,  mode = {"n"},  desc = "Go to next diagnostic"                            },
      { "<A-k>", function() vim.diagnostic.jump({ count = -1 }) end, mode = {"n"},  desc = "Go to previous diagnostic"                        },
      { "<leader>gd", "<CMD>Trouble diagnostics toggle<CR>",                        desc = "[Trouble] Toggle buffer diagnostics"              },
      { "<leader>gs", "<CMD>Trouble symbols toggle focus=false<CR>",                desc = "[Trouble] Toggle symbols "                        },
      { "<leader>gl", "<CMD>Trouble lsp toggle focus=false win.position=right<CR>", desc = "[Trouble] Toggle LSP definitions/references/...", },
      { "<leader>gL", "<CMD>Trouble loclist toggle<CR>",                            desc = "[Trouble] Location List"                          },
      { "<leader>gq", "<CMD>Trouble qflist toggle<CR>",                             desc = "[Trouble] Quickfix List"                          },

      -- { "grr", "<CMD>Trouble lsp_references focus=true<CR>",         mode = { "n" }, desc = "[Trouble] LSP references"                        },
      -- { "gD", "<CMD>Trouble lsp_declarations focus=true<CR>",        mode = { "n" }, desc = "[Trouble] LSP declarations"                      },
      -- { "gd", "<CMD>Trouble lsp_type_definitions focus=true<CR>",    mode = { "n" }, desc = "[Trouble] LSP type definitions"                  },
      -- { "gri", "<CMD>Trouble lsp_implementations focus=true<CR>",    mode = { "n" }, desc = "[Trouble] LSP implementations"                   },
    },

		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
                -- stylua: ignore
                keys = {
                  ["<c-t>"] = { "trouble_open", mode = { "n", "i" }, },
                },
							},
						},
					},
				})
			end,
		},
		opts = {
			focus = false,
			warn_no_results = false,
			open_no_results = true,
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				---`row` and `col` values relative to the editor
				position = { 0.3, 0.3 },
				size = { width = 0.6, height = 0.5 },
				zindex = 200,
			},
		},

		config = function(_, opts)
			require("trouble").setup(opts)
			local symbols = require("trouble").statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				-- The following line is needed to fix the background color
				-- Set it to the lualine section you want to use
				-- hl_group = "lualine_b_normal",
			})

			-- Insert status into lualine
			opts = require("lualine").get_config()
			table.insert(opts.winbar.lualine_b, 1, {
				symbols.get,
				cond = symbols.has,
			})
			require("lualine").setup(opts)
		end,
	},
}
