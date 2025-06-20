return {
	"saghen/blink.cmp",
	-- 自己构建，需要rust的nightly版本
	build = "cargo build --release",
	-- optional: provides snippets for the snippet source
	dependencies = {
		-- 'rafamadriz/friendly-snippets'
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
	},

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			-- 使用预设按键
			preset = "default",
			-- 向下选择补全项
			-- ["<A-j>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
			-- 向上选择补全项
			-- ["<A-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
			-- 向下选择补全项
			["<C-n>"] = {
				function(cmp)
					return cmp.select_next({ auto_insert = false })
				end,
				"fallback",
			},
			-- 向上选择补全项
			["<C-p>"] = {
				function(cmp)
					return cmp.select_prev({ auto_insert = false })
				end,
				"fallback",
			},

			-- 向上滚动补全文档
			-- ["<C-u>"] = { "scroll_documentation_up", "fallback" },
			-- 向下滚动补全文档
			-- ["<C-d>"] = { "scroll_documentation_down", "fallback" },

			-- 确认选中当前补全项
			["<Tab>"] = {
				function(cmp)
					return cmp.accept()
				end,
				"fallback",
			},
			-- 确认选中当前补全项
			-- ["<CR>"] = { function(cmp) return cmp.accept() end, "fallback", },
			-- 关闭补全菜单并直接换行
			-- ["<S-CR>"] = { function(cmp) cmp.hide() return false end, "fallback", },

			-- 显示/隐藏补全菜单
			["<A-/>"] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.hide()
					else
						return cmp.show()
					end
				end,
				"fallback",
			},

			-- 仅显示来自缓冲区（buffer）的补全建议
			-- ["<A-n>"] = { function(cmp) cmp.show({ providers = {"buffer"} }) end, },
			-- ["<A-p>"] = { function(cmp) cmp.show({ providers = {"buffer"} }) end, },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		-- completion = { documentation = { auto_show = false } },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = function()
				local success, node = pcall(vim.treesitter.get_node)
				-- 如果当前在注释区域，则只启用buffer补全
				if
					success
					and node
					and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
				then
					return { "buffer" }
				-- 默认使用lsp（语言服务器），path（路径），snippets（代码片段），buffer（缓冲区文本）
				else
					return { "lsp", "path", "snippets", "buffer" }
				end
			end,
			-- 补全源优先级
			providers = {
				-- 文件路径补全
				path = {
					score_offset = 95,
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
				-- 当前缓冲区文本补全
				buffer = {
					score_offset = 20,
				},
				-- 语言服务器补全
				lsp = {
					-- Default
					-- Filter text items from the LSP provider, since we have the buffer provider for that
					transform_items = function(_, items)
						return vim.tbl_filter(function(item)
							return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
						end, items)
					end,
					score_offset = 60,
					fallbacks = { "buffer" },
				},
				-- Hide snippets after trigger character
				-- Trigger characters are defined by the sources. For example, for Lua, the trigger characters are ., ", '.
				-- 代码片段补全
				snippets = {
					score_offset = 70,
					should_show_items = function(ctx)
						return ctx.trigger.initial_kind ~= "trigger_character"
					end,
					fallbacks = { "buffer" },
				},
				-- 命令行补全
				cmdline = {
					min_keyword_length = 2,
					-- Ignores cmdline completions when executing shell commands
					enabled = function()
						return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
					end,
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = {
			-- 优先使用rust实现
			implementation = "prefer_rust_with_warning",
			-- 先匹配exact（完全一致），再按score（匹配分数）和sort_text（排序文本）排序
			sorts = { "exact", "score", "sort_text" },
		},

		completion = {
			-- NOTE: some LSPs may add auto brackets themselves anyway
			-- 当选中补全项（如函数名）时，自动添加括号
			accept = { auto_brackets = { enabled = true } },
			list = {
				selection = {
					-- 默认选中第一项
					preselect = true,
					-- 不自动插入选中项（需手动确认）
					auto_insert = false,
				},
			},
			menu = {
				border = "rounded",
				max_height = 20,
				draw = {
					-- 列布局
					columns = {
						-- 第一列：补全项+描述（间隔1空格）
						{ "label", "label_description", gap = 1 },
						-- 第二列：类型图标+类型名称
						{ "kind_icon", "kind" },
					},
					components = {
						-- 类型图标
						kind_icon = {
							-- 不显示省略号
							ellipsis = false,
							text = function(ctx)
								-- 动态获取图标:
								-- 1.优先用ctx.kind_icon（如果已有）
								-- 2.如果是路径（Path），用nvim-web-devicons的文件图标
								-- 3.否则的用lspkind的符号图标
								local icon = ctx.kind_icon
								if icon then
								-- Do nothing
								elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
								end
								-- 返回图标+间隔
								return icon .. ctx.icon_gap
							end,
							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								-- 同上逻辑，但返回图标的高亮组
								local hl = ctx.kind_hl
								if hl then
								-- Do nothing
								elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				-- 自动显示文档
				auto_show = true,
				-- Delay before showing the documentation window
				-- 延迟200ms后显示（放闪烁）
				auto_show_delay_ms = 200,
				window = {
					min_width = 10,
					max_width = 120,
					max_height = 20,
					border = "rounded",
					-- 不透明
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
					-- Note that the gutter will be disabled when border ~= 'none'
					-- 显示滚动条
					scrollbar = true,
					-- Which directions to show the documentation window,
					-- for each of the possible menu window directions,
					-- falling back to the next direction when there's not enough space
					-- 弹窗显示方向优先级
					direction_priority = {
						-- 补全菜单在北侧时，优先东、西、北、南
						menu_north = { "e", "w", "n", "s" },
						-- 补全菜单在南侧时，优先东、西、南、北
						menu_south = { "e", "w", "s", "n" },
					},
				},
			},

			-- Displays a preview of the selected item on the current line
			-- 幽灵文本，在代码中半透明显示补全后的效果
			ghost_text = {
				-- 启用幽灵文本（预览补全效果）
				enabled = true,
				-- Show the ghost text when an item has been selected
				-- 选中项时显示
				show_with_selection = true,
				-- Show the ghost text when no item has been selected, defaulting to the first item
				-- 未选中时不显示
				show_without_selection = false,
				-- Show the ghost text when the menu is open
				-- 补全菜单打开时显示
				show_with_menu = true,
				-- Show the ghost text when the menu is closed
				-- 补全菜单关闭时也显示
				show_without_menu = true,
			},
		},

		-- 函数签名帮助，控制函数参数提示的显示行为，当输入函数名和左括号时触发
		signature = {
			enabled = true,
			window = {
				min_width = 1,
				max_width = 100,
				max_height = 10,
				border = "single", -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
				-- 不透明（0=完全可见，100=完全透明）
				winblend = 0,
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				-- 不显示滚动条
				scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
				-- Which directions to show the window,
				-- falling back to the next direction when there's not enough space,
				-- or another window is in the way
				-- 优先在光标上方（north）显示弹窗
				direction_priority = { "n" },
				-- Disable if you run into performance issues
				-- 使用Treesitter高亮参数
				treesitter_highlighting = true,
				-- 显示函数文档说明
				show_documentation = true,
			},
		},
		cmdline = {
			completion = {
				menu = {
					-- 输入时自动显示补全菜单
					auto_show = true,
				},
			},
			keymap = {
				-- 不使用预设键位
				preset = "none",
				-- 向下选择补全项
				-- ["<A-j>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
				-- 向上选择补全项
				-- ["<A-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
				-- 向上选择补全项
				["<C-p>"] = {
					function(cmp)
						return cmp.select_prev({ auto_insert = false })
					end,
					"fallback",
				},
				-- 向下选择补全项
				["<C-n>"] = {
					function(cmp)
						return cmp.select_next({ auto_insert = false })
					end,
					"fallback",
				},
				-- 确认选中当前补全项
				["<Tab>"] = {
					function(cmp)
						return cmp.accept()
					end,
					"fallback",
				},
				-- 确认选中当前补全项并执行命令（仅在`:`模式生效）
				["<CR>"] = {
					function(cmp)
						if vim.fn.getcmdtype() == ":" then
							return cmp.accept_and_enter()
						end
						return false
					end,
					"fallback",
				},
				-- 显示/隐藏补全菜单
				["<A-/>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.hide()
						else
							return cmp.show()
						end
					end,
					"fallback",
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
