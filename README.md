# keymap
leader = " "
local_leader = ","

## n, x, o, i, v, s, c, t
n代表normal模式
x代表visual模式
o代表operator pending模式
i代表insert模式
v代表visual和select模式
s代表select模式
c代表command模式
t代表terminal模式

## core.lazy
:Lazy 显示lazy界面

## core.keymap
### insert mode
jk = <Esc>
<C-h> 左移
<C-l> 右移
<C-j> 下移
<C-k> 上移

### visual mode
J 与下一行交换位置
K 与上一行交换位置
<S-H>（即H）移动到行首
<S-L>（即L）移动到行尾
qq :q
Q :qa

### normal mode
<C-h> 移动到左边的窗口
<C-l> 移动到右边的窗口
<C-j> 移动到下边的窗口
<C-k> 移动到上边的窗口
<leader>sv 垂直分屏
<leader>sh 水平分屏
<!-- <leader>nh 取消高亮（用于搜索后） -->
<S-H>（即H）移动到行首
<S-L>（即L）移动到行尾
<!-- <A-z> 切换wrap开关（wrap开启时，长行会自动换行显示，仅视图换行） -->
qq :q
Q :qa

### operator pending mode
> 在normal模式下输入一个操作符，但是尚未指定操作范围时进入的模式
> Normal 模式 → 按 `d` → 进入 Operator-Pending 模式 → 再按 `w`（删除一个单词）
<S-H>（即H）移动到行首
<S-L>（即L）移动到行尾

### select mode
> 在 Visual 模式下使用<C-g>进入 Select 模式
> 选择模式下的操作类似于普通文本编辑器中的选择操作
> Visual模式下是选中文本，然后执行命令操作
> Select模式下是选中文本，然后直接输入文本替换，或者使用Backspace删除
> 替换或者删除文本后会自定进入insert模式
J 与下一行交换位置
K 与上一行交换位置

## core.lsp
### normal mode
<!-- gd 跳转到定义 -->
<!-- gD 跳转到声明 -->
K 显示悬停文档
<leader>d 打开浮动窗口显示诊断信息
<leader>gk 显示函数签名帮助
<leader>wa 添加工作区文件夹
<leader>wr 移除工作区文件夹
<leader>wl 列出工作区文件夹
<leader>rn 重命名符号
<leader>th 切换内联提示开关

## plugins.ai
### copilot.lua
:Copilot auth 身份验证

### codecompanion.nvim
:CodeCompanionChat 打开聊天窗口，insert模式下按<C-s>提交对话，normal mode使用<CR>
:cc your prompt 调用内联助手，助手会评估提示词，选择直接写入代码还是打开聊天窗口
example: `:cc #{buffer} your prompt` `:'<,'>cc /explain`
:CodeCompanionCmd your prompt创建neovim命令
> 通过`#{var}`访问[变量](https://codecompanion.olimorris.dev/usage/chat-buffer/variables.html)，
> 通过`/`运行[指令](https://codecompanion.olimorris.dev/usage/chat-buffer/slash-commands.html)，
> 通过`@{tool}`访问[工具](https://codecompanion.olimorris.dev/usage/chat-buffer/tools.html#available-tools)

#### normal mode
<leader>cca 打开选项窗口
<leader>ccc 切换聊天窗口

#### visual mode
<leader>cca 打开选项窗口
<leader>ccc 切换聊天窗口
<leader>ccp 将选中的内容发送到聊天窗口

#### select mode
<leader>cca 打开选项窗口
<leader>ccc 切换聊天窗口
<leader>ccp 将选中的内容发送到聊天窗口

## plugins.edit
### flash
#### normal mode
<leader>fj 输入要搜索的内容，会高亮所有匹配项，并为每个匹配项分配一个跳转标签，输入标签即可跳转
<leader>ft 会高亮光标所在的语法节点以及所有父级节点，使用跳转标签来跳转到对应语法节点，或者使用`;`和`,`来扩大或缩小选择范围
<leader>fs 输入要搜索的内容，会高亮匹配项相邻的treesitter节点，选择标签即可选中选区
<leader>fl 高亮所有行（包括空行），输入标签跳转到行首
<leader>fe 高亮所有非空行，输入标签跳转到行尾

#### visual mode
<leader>fj 输入要搜索的内容，会高亮所有匹配项，并为每个匹配项分配一个跳转标签，输入标签即可跳转
<leader>ft 会高亮光标所在的语法节点以及所有父级节点，使用跳转标签来跳转到对应语法节点，或者使用`;`和`,`来扩大或缩小选择范围
<leader>fs 输入要搜索的内容，会高亮匹配项相邻的treesitter节点，选择标签即可选中选区
<leader>fl 高亮所有行（包括空行），输入标签跳转到行首
<leader>fe 高亮所有非空行，输入标签跳转到行尾

#### operator pending mode
<leader>fj 输入要搜索的内容，会高亮所有匹配项，并为每个匹配项分配一个跳转标签，输入标签即可跳转
<leader>ft 会高亮光标所在的语法节点以及所有父级节点，使用跳转标签来跳转到对应语法节点，或者使用`;`和`,`来扩大或缩小选择范围
<leader>fs 输入要搜索的内容，会高亮匹配项相邻的treesitter节点，选择标签即可选中选区
<leader>fl 高亮所有行（包括空行），输入标签跳转到行首
<leader>fe 高亮所有非空行，输入标签跳转到行尾

#### command mode
> 触发方式: `:`进入命令行，`/`和`?`进入搜索
<c-f> 对常规搜索启用闪搜的开关

### neogen
#### normal mode
<leader>nf 为当前函数生成注释
<leader>nc 为当前类生成注释

### todo_comments
#### normal mode
<leader>st 查找所有特殊注释（除了NOTE）
<leader>sT 查找所有特殊注释（包括NOTE）

### mini.surround
#### normal mode
sd <char> 删除包围的char，比如`sd"`删除包围的双引号
sf <char> 跳转到下一个包围的char
sF <char> 跳转到上一个包围的char
sh <char> 高亮包围的符号
sr <char1> <char2> 用char2替换包围的char1
l 后缀键
n 后缀键

#### visual mode
sa <char> 在选中内容的两端添加char

### mini.comment
> 定义了文本对象`gc`，可以选中整个注释块
#### normal mode
gc <motion> 注释/取消注释
gcc 注释/取消注释当前行

#### visual mode
gc 注释/取消注释选中内容

### multicursor
> 多光标进入编辑模式时编辑内容只会改变其中一行，但是回到normal模式后，所有行都会被修改
#### normal mode
<esc> 退出多光标模式

#### visual mode
mI 在选中内容之前插入光标
mA 在选中内容之后插入光标

## plugins.lsp
### mason.nvim
:Mason 打开mason界面

### conform.nvim
> 保存时自动格式化
<leader>tf 开启/关闭自动格式化

### trouble.nvim
> 在Snacks选择器界面可以用tab选中文件，按<c-t>在trouble的窗口打开文件
> 如果不选中则打开全部文件
#### normal mode
<A-j> 跳转到下一个诊断
<A-k> 跳转到上一个诊断
<!-- <leader>td 开启/关闭全局诊断信息面板 -->
<leader>ts 开启/关闭符号面板，查看变量、函数等符号信息
<leader>tl 开启/关闭LSP面板，查看定义、引用等LSP信息
<leader>tL 开启/关闭位置列表
<leader>tq 开启/关闭快速修复列表

### snacks.nvim
> 按<esc>从Insert模式返回到Normal模式
> 再按一次<esc>退出Snacks选择器
> 在normal模式下按?可以查看帮助
#### picker
<Tab> 选中并向上移动
<S-Tab> 选中并向下移动
<A-UP> 上一个历史命令
<A-DOWN> 下一个历史命令
<A-j> 向下移动
<A-k> 向上移动
<C-u> 预览窗口向上滚动
<C-d> 预览窗口向下滚动
<A-u> 列表窗口向上滚动
<A-d> 列表窗口向下滚动
<C-j> 同<A-j>
<C-k> 同<A-k>
#### normal mode
<A-d> 退出当前缓冲区
<A-t> 开启/关闭terminal
<leader>sn 通知选择器
<leader>un 关闭所有通知
<leader><space> 智能文件选择器
<leader>sb neovim中已打开的缓冲区选择器
<leader>sf 文件选择器
<leader>sp 项目选择器
<leader>sR 最近打开的文件
<c-g> 打开lazygit，需要安装lazygit
<leader>ggl git log
<leader>ggd git diff 需要下载delta `cargo install git-delta`
<leader>ggb git blame
<leader>ggB 在github中打开当前文件的当前行
<leader>sg 全局搜索文本
<leader>s" 查看寄存器
<leader>s/ 显示`/`和`?`的搜索记录
<leader>ts 显示/关闭拼写检查
<leader>sA autocmd选择器
<leader>s: 历史命令
<leader>sd 查看所有诊断信息
<leader>sD 查看当前缓冲区的诊断信息
<leader>sh 查看neovim的帮助文档
<leader>sI 搜索icon
<leader>sk 查看键位映射
<leader>sj 查看跳转历史
<leader>sl 查看位置列表
<leader>sm 标记选择器
<leader>se 插件选择器
<leader>sq 快速修复列表
<leader>sr 恢复上一次的选择器
<leader>su 撤销历史
gd 跳转到定义
gD 跳转到声明
gr 跳转到引用
gI 跳转到实现
gy 列出所有类型定义
<leader>ss lsp symbol
<leader>sS lsp workspace symbol
]] 跳转到下一个引用
[[ 跳转到上一个引用
<leader>z 开启/关闭禅模式，开启禅模式后只有当前语法块会高亮显示
<leader>Z 最大化/还原当前窗口
<leader>ta 启用/禁用动画
<leader>tb 切换亮暗背景
<leader>tS 启用/禁用滚动动画
<leader>tw 启用/禁用wrap
<leader>tr 启用/禁用相对行号
<leader>td 启用/禁用诊断信息
<leader>tD 启用/禁用dim，dim会调暗非活动区域
<leader>tn 启用/禁用行号
<leader>tc 调整隐藏文本级别，开启conceallevel = 2,关闭conceallevel = 0，关闭时显示所有符号
<leader>tT 启用/禁用treesitter高亮
<!-- <leader>th 启用/禁用内联提示 -->
<leader>tg 启用/禁用缩进提示线
<leader>tpp 启用/禁用性能分析
<leader>tph 启用/禁用性能分析的高亮显示

## plugins.ui
### barbar.nvim
#### normal mode
<A-1> - <A-9> 切换到对应编号的标签页
<A-h> 切换到左边的标签页
<A-l> 切换到右边的标签页
<A-Left> 将当前标签页向左移动
<A-Right> 将当前标签页向右移动

### nvim-tree.lua
#### normal mode
<leader>e 打开/关闭文件树
在文件树中:
o 打开/关闭目录或打开文件
a 创建文件
r 重命名
x 剪切
c 拷贝
p 粘贴
d 删除

### mini.diff
#### normal
<leader>to 开启/关闭diff视图

### which-key.nvim
#### normal mode
<leader>? 显示所有快捷键

### gitsigns.nvim
> ih 文本对象，选中当前hunk
#### normal mode
]h 跳转到下一个hunk
[h 跳转到上一个hunk
]H 跳转到最后一个hunk
[H 跳转到第一个hunk
<leader>ggs 暂存当前hunk
<leader>ggr 撤销当前hunk的修改
<leader>ggS 暂存当前文件
<leader>ggR 撤销当前文件的所有修改
<leader>ggp 浮动窗口预览当前hunk的修改
<leader>ggP 行内预览当前hunk的修改
<leader>ggQ 将所有差异显示到quickfix列表
<leader>ggq 当前文件的所有差异显示到quickfix列表
<leader>tgb 切换显示当前行的git blame信息
<leader>tgw 切换单词级差异高亮

### nvim-hlslens
> 执行搜索命令后，在匹配结果旁显示序号，如[1/5]
> 覆盖vim原生的n, N, *, #, g*, g#
#### normal mode
n 下一个匹配项，居中屏幕
N 上一个匹配项，居中屏幕
* 正向单词搜索
# 反向单词搜索
// 清除搜索高亮

### nvim-ufo
> 禁用了原生的zE、zx、zX
#### normal mode
T 显示悬浮窗口预览折叠内容，如果没有折叠则调用LSP hover
zM 折叠所有代码
zR 展开所有代码
zm 增加折叠级别
zr 减少折叠级别
zS 设置折叠层级，比如3zS，只展开3层嵌套的代码

## plugins.completion
### blink.cmp
#### insert mode
<C-n> 选择下一个补全项
<C-p> 选择上一个补全项
<C-u> 向上滚动补全文档
<C-d> 向下滚动补全文档
<Tab> 确认选中当前补全项
<A-/> 显示/隐藏补全菜单

#### terminal mode
<C-n> 选择下一个补全项
<C-p> 选择上一个补全项
<C-u> 向上滚动补全文档
<C-d> 向下滚动补全文档
<Tab> 确认选中当前补全项
<CR> 确认选中当前补全项
<A-/> 显示/隐藏补全菜单
