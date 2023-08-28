" 设置 <Leader> key
let mapleader = "\<space>"
" 使用系统剪切板
set clipboard=unnamed

" ----- settings ----
if exists('g:vscode')
    " 向下移动 5 行
    nnoremap J 5j

    " 向上移动 5 行
    nnoremap K 5k

    " 显示命令面板
    nnoremap <Leader>p <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>

    " 打开设置面板
    nnoremap <Leader>, <Cmd>call VSCodeNotify('workbench.action.openSettings')<CR>

    " 聚焦到下一个编辑器组
    nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>

    " 聚焦到上一个编辑器组
    nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>

    " 聚焦到左侧编辑器组
    nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>

    " 聚焦到右侧编辑器组
    nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>

    " 打开全局按键绑定面板
    nnoremap <Leader>fk <Cmd>call VSCodeNotify('workbench.action.openGlobalKeybindings')<CR>

    " 选择主题
    nnoremap <Leader>ft <Cmd>call VSCodeNotify('workbench.action.selectTheme')<CR>

    " 快速打开已打开的文件
    nnoremap <Leader>ff <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

    " 查找单词
    nnoremap <Leader>fw <Cmd>call VSCodeNotify('actions.find')<CR>

    " 在所有文件中查找单词
    nnoremap <Leader>fW <Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>

    " 切换侧边栏可见性
    nnoremap <Leader>e <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

    " 切换到资源管理器
    nnoremap <Leader>o <Cmd>call VSCodeNotify('workbench.action.toggleFilesExplorer')<CR>

    " 切换注释行
    nnoremap <Leader>/ <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>

    " 切换到上一个选项卡
    nnoremap <Leader>bp <Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>

    " 切换到下一个选项卡
    nnoremap <Leader>bn <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>

    " 保存文件
    nnoremap <Leader>w <Cmd>call VSCodeNotify('workbench.action.files.save')<CR>

    " 关闭当前编辑器
    nnoremap <Leader>c <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

    " 格式化文档
    nnoremap <Leader>lf <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

    " 重命名符号
    nnoremap <Leader>lr <Cmd>call VSCodeNotify('editor.action.rename')<CR>

    " 打开 Git 面板
    nnoremap <Leader>gg <Cmd>call VSCodeNotify('workbench.view.scm')<CR>W

else
    " 以正常模式启动nvim时加载的配置项
    " 显示行号
    set number
    " 设置相对行号
    set relativenumber
    " 设置行宽
    set textwidth=80
    " 设置自动换行
    set wrap
    " 是否显示状态栏
    set laststatus=2
    " 语法高亮
    syntax on
    " 支持鼠标
    set mouse=a
    " 设置编码格式
    set encoding=utf-8
    " 启用256色
    set t_Co=256
    " 开启文件类型检查
    filetype indent on
    " 设置自动缩进
    set autoindent
    " 设置tab缩进数量
    set tabstop=2
    " 设置>>与<<的缩进数量
    set shiftwidth=2
    " 将缩进转换为空格
    set expandtab
    " 自动高亮匹配符号
    set showmatch
    " 自动高亮匹配搜索结果
    set nohlsearch
    " 开启逐行搜索
    set incsearch
    " 开启类型检查
    " set spell spelllang
    " 开启命令补全
    set wildmenu
    " 不创建备份文件
    set nobackup
    " 不创建交换文件
    set noswapfile
    " 多窗口下光标移动到其他窗口时自动切换工作目录
    set autochdir
endif
