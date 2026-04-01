vim.g.mapleader = " "
vim.g.maplocaleader = " "

vim.opt.termguicolors = true
vim.cmd.colorscheme("retrobox")
vim.opt.number = true                             -- line number
vim.opt.relativenumber = true                     -- relative line numbers
vim.opt.cursorline = true                         -- highlight current line
vim.opt.wrap = false                              -- do not wrap lines by default
vim.opt.scrolloff = 10                            -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10                        -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 4                               -- tabwidth
vim.opt.shiftwidth = 4                            -- indent width
vim.opt.softtabstop = 4                           -- soft tab stop not tabs on tab/backspace
--vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true                        -- smart auto-indent
vim.opt.autoindent = true                         -- copy indent from current line

vim.opt.ignorecase = true                         -- case insensitive search
vim.opt.smartcase = true                          -- case sensitive if uppercase in string
vim.opt.hlsearch = true                           -- highlight search matches
vim.opt.incsearch = true                          -- show matches as you type

vim.opt.signcolumn = "yes"                        -- always show a sign column
vim.opt.colorcolumn = "100"                       -- show a column at 100 position chars
vim.opt.showmatch = true                          -- highlights matching brackets
vim.opt.cmdheight = 1                             -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false                          -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10                            -- popup menu height
vim.opt.pumblend = 10                             -- popup menu transparency
vim.opt.winblend = 0                              -- floating window transparency
vim.opt.conceallevel = 0                          -- do not hide markup
vim.opt.concealcursor = ""                        -- do not hide cursorline in markup
vim.opt.lazyredraw = true                         -- do not redraw during macros
vim.opt.synmaxcol = 300                           -- syntax highlighting limit

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 50
vim.opt.conceallevel = 2
vim.opt.statusline = "no"
vim.opt.shell = vim.loop.os_uname().sysname:lower():find("windows") and "pwsh.exe" or os.getenv("SHELL")
vim.opt.winborder = "rounded"

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save current buffer to file" })
vim.keymap.set("n", "<C-D-h>", "<C-w>left", { desc = "Move to left split" })
vim.keymap.set("n", "<C-D-j>", "<C-w>down", { desc = "Move to down split" })
vim.keymap.set("n", "<C-D-k>", "<C-w>up", { desc = "Move to up split" })
vim.keymap.set("n", "<C-D-l>", "<C-w>right", { desc = "Move to right split" })


local function set_transparent() -- set UI component to transparent
	local groups = {
		"Normal",
		"NormalNC",
		"EndOfBuffer",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"StatusLine",
		"StatusLineNC",
		"TabLine",
		"TabLineFill",
		"TabLineSel",
		"ColorColumn",
	}
	for _, g in ipairs(groups) do
		vim.api.nvim_set_hl(0, g, { bg = "none" })
	end
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false                  -- do not create a backup file
vim.opt.writebackup = false             -- do not write to a backup file
vim.opt.swapfile = false                -- do not create a swapfile
vim.opt.undofile = true                 -- do create an undo file
vim.opt.undodir = undodir               -- set the undo directory
vim.opt.updatetime = 300                -- faster completion
vim.opt.timeoutlen = 500                -- timeout duration
vim.opt.ttimeoutlen = 0                 -- key code timeout
vim.opt.autoread = true                 -- auto-reload changes if outside of neovim
vim.opt.autowrite = false               -- do not auto-save

vim.opt.hidden = true                   -- allow hidden buffers
vim.opt.errorbells = false              -- no error sounds
vim.opt.backspace = "indent,eol,start"  -- better backspace behaviour
vim.opt.autochdir = false               -- do not autochange directories
vim.opt.iskeyword:append("-")           -- include - in words
vim.opt.path:append("**")               -- include subdirs in search
vim.opt.selection = "inclusive"         -- include last char in selection
vim.opt.mouse = "a"                     -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true               -- allow buffer modifications
vim.opt.encoding = "utf-8"              -- set encoding

vim.opt.guicursor =
"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr"                          -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99                               -- start with all folds open

vim.opt.splitbelow = true                            -- horizontal splits go below
vim.opt.splitright = true                            -- vertical splits go right

vim.opt.wildmenu = true                              -- tab completion
vim.opt.wildmode =
"longest:full,full"                                  -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60")               -- improve diff display
vim.opt.redrawtime = 10000                           -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000                        -- increase max memory


-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.py",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.css",
		"*.scss",
		"*.html",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.c",
		"*.cpp",
		"*.h",
		"*.hpp",
	},
	callback = function(args)
		-- avoid formatting non-file buffers (helps prevent weird write prompts)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
				has_efm = true
				break
			end
		end
		if not has_efm then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == "efm"
			end,
		})
	end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})
