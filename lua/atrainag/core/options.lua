vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- encoding
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

opt.hlsearch = true

-- show the last command in the status line
opt.showcmd = true

-- hiding the cmd bar below
opt.cmdheight = 0
opt.laststatus = 0

-- at least n line when scrolling
opt.scrolloff = 10

-- command preview
opt.inccommand = "split"

-- title for files
opt.title = true

-- line number configurations
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.smarttab = true
opt.breakindent = true

opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- finding subdirectories files
opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })

opt.formatoptions:append("r")
