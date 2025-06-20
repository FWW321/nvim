-- 在MacOS上将左Option键映射为Alt键
-- 以ghostty为例
-- macos-option-as-alt = left
-- 可选（解除终端对alt+left(right)的绑定，这样会直接透传给应用程序（如neovim）处理）
-- keybind = alt+left=unbind
-- keybind = alt+right=unbind
require("core.options")
require("core.keymaps")
require("core.lazy")
