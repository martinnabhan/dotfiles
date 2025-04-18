-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ "akinsho/nvim-bufferline.lua" },
		{ "brenoprata10/nvim-highlight-colors" },
		{
			"folke/lazydev.nvim",
			config = function()
				require("lazydev").setup()
			end,
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			opts = {
				bigfile = { enabled = true },
				image = { enabled = false },
				picker = {
					auto_close = false,
					enabled = true,
					win = {
						input = {
							keys = {
								["<C-g>"] = { "cancel", mode = "i" },
							},
						},
					},
				},
			},
		},
		{
			"2KAbhishek/pickme.nvim",
			cmd = "PickMe",
			event = "VeryLazy",
			config = function()
				require("pickme").setup({
					add_default_keybindings = false,
				})
			end,
		},
		{ "hoob3rt/lualine.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "hrsh7th/nvim-cmp" },
		{ "jcha0713/cmp-tw2css" },
		{ "kyazdani42/nvim-tree.lua" },
		{ "kyazdani42/nvim-web-devicons" },
		{ "mcauley-penney/visual-whitespace.nvim" },
		{ "moll/vim-bbye" },
		{ "navarasu/onedark.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvimtools/none-ls.nvim" },
		{ "nvimtools/none-ls-extras.nvim" },
		{
			"olimorris/codecompanion.nvim",
			config = function()
				require("codecompanion").setup({
					strategies = {
						chat = {
							adapter = "gemini",
						},
						inline = {
							adapter = "gemini",
						},
					},
				})
			end,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},
		{ "onsails/lspkind-nvim" },
		{
			"Sebastian-Nielsen/better-type-hover",
			ft = { "typescript", "typescriptreact" },
			config = function()
				require("better-type-hover").setup({
					openTypeDocKeymap = "<C-h>",
				})
			end,
		},
		{
			"sindrets/diffview.nvim",
			config = function()
				require("diffview").setup()
			end,
		},
		{ "stevearc/conform.nvim" },
		{ "pantharshit00/vim-prisma" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "wbthomason/packer.nvim" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
	},
})

vim.loader.enable()

require("visual-whitespace").setup({})

require("bufferline").setup({
	highlights = {
		buffer_selected = { italic = false, indicator = false },
	},
	options = {
		always_show_bufferline = false,
		indicator = { style = "none" },
		max_name_length = 2000,
		offsets = { { filetype = "NvimTree", text = "", highlight = "Directory" } },
		separator_style = { "", "" },
		show_buffer_close_icons = false,
		show_close_icon = false,
	},
})

local cmp = require("cmp")

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	expand = function(args)
		vim.snippet.expand(args.body)
	end,
	formatting = {
		expandable_indicator = false,
		fields = { cmp.ItemField.Abbr, cmp.ItemField.Menu, cmp.ItemField.Kind },
		format = function(entry, item)
			local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })

			item = require("lspkind").cmp_format({})(entry, item)

			if color_item.abbr_hl_group then
				item.kind_hl_group = color_item.abbr_hl_group
				item.kind = color_item.abbr
			end

			return item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = function(fallback)
			if not cmp.select_next_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,

		["<S-Tab>"] = function(fallback)
			if not cmp.select_prev_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "cmp-tw2css" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
	}, {
		{ name = "buffer" },
	}),
})

vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })

require("lualine").setup({
	options = {
		component_separators = "|",
		globalstatus = 3,
		section_separators = "",
		theme = "onedark",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { { "diagnostics", sources = { "nvim_lsp" } }, "filetype" },
		lualine_z = { "location" },
	},
})

require("onedark").setup({
	colors = { bg2 = "" },
	highlights = {
		TabLineFill = { bg = "transparent" },
	},
	lualine = { transparent = true },
	transparent = true,
})

require("onedark").load()

require("mason").setup()

require("mason-lspconfig").setup({
	automatic_installation = true,
	ensure_installed = {
		"bashls",
		"cssls",
		"eslint",
		"graphql",
		"html",
		"jsonls",
		"lua_ls",
		"prismals",
		"tailwindcss",
		"ts_ls",
		"vimls",
		"yamlls",
	},
})

require("mason-lspconfig").setup_handlers({
	function(server_name)
		if server_name == "lua_ls" then
			require("lspconfig")[server_name].setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
						},
					},
				},
			})
		else
			require("lspconfig")[server_name].setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
		end
	end,
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "eslint_d", "prettierd" },
		json = { "prettierd" },
		typescriptreact = { "eslint_d", "prettierd" },
		yaml = { "prettierd" },
	},
	format_on_save = {
		timeout_ms = 10000,
		lsp_format = "fallback",
	},
})

require("nvim-highlight-colors").setup({})

require("nvim-tree").setup({
	actions = { open_file = { quit_on_open = true } },
	filters = { dotfiles = true },
	renderer = { icons = { show = { git = false } }, special_files = {} },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"css",
		"csv",
		"dockerfile",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"nginx",
		"prisma",
		"python",
		"regex",
		"sql",
		"tsx",
		"typescript",
		"vim",
		"yaml",
	},
	highlight = { additional_vim_regex_highlighting = false, enable = true },
	indent = { enable = true },
	modules = {},
	sync_install = false,
	ignore_install = {},
	auto_install = true,
})

vim.api.nvim_set_keymap("n", "ga", ":lua vim.lsp.buf.code_action()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gn", ":lua vim.diagnostic.goto_next()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gp", ":lua vim.diagnostic.goto_prev()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-d>", ":Bdelete<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-g>", ":Bdelete!<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":lua vim.lsp.buf.hover()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":bprevious<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":bnext<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-t>", ":terminal<cr>i", { silent = true })
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { silent = true })

local pickme = require("pickme")

vim.keymap.set("n", "<C-i>", function()
	pickme.pick("files", { hidden = true, ignored = true, title = "All Files" })
end)

vim.keymap.set("n", "<C-o>", function()
	pickme.pick("git_files", { hidden = true, title = "Git Files" })
end)

vim.keymap.set("n", "<C-p>", function()
	pickme.pick("live_grep", { hidden = true, title = "Code" })
end)

vim.cmd("autocmd BufEnter * set fillchars=eob:\\ ")

vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float({ focusable = false })")

vim.cmd("command! Bash :terminal")
vim.cmd("command! Config e $MYVIMRC")
vim.cmd("command! Profile e $HOME/.zshrc")
vim.cmd("command! Reload so $MYVIMRC")
vim.cmd("command! SSH e $HOME/.ssh/config")
vim.cmd("filetype indent on")
vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282828")
vim.cmd("highlight NvimTreeNormal guibg=#282828")

vim.fn.sign_define("DiagnosticSignError", {
	numhl = "DiagnosticSignError",
	text = "󰅚",
	texthl = "DiagnosticSignError",
})

vim.fn.sign_define("DiagnosticSignHint", {
	numhl = "DiagnosticSignHint",
	text = "󰌶",
	texthl = "DiagnosticSignHint",
})

vim.fn.sign_define("DiagnosticSignWarning", {
	numhl = "DiagnosticSignWarning",
	text = "󰀪",
	texthl = "DiagnosticSignWarning",
})

vim.diagnostic.config({ virtual_text = false })
vim.o.clipboard = "unnamed"
vim.o.completeopt = "menuone,noselect"
vim.o.expandtab = true
vim.o.hidden = true
vim.o.mouse = ""
vim.o.scrollback = 100000
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "cI"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undodir = vim.fn.expand("~/.config/nvim/undo/")
vim.o.undofile = true
vim.o.updatetime = 100
vim.wo.wrap = false

-- stop eslint_d and prettierd when exiting nvim
vim.api.nvim_create_augroup("stop-nvim-daemons", {})

vim.api.nvim_create_autocmd("ExitPre", {
	callback = function()
		vim.fn.jobstart("~/.config/nvim/stop-nvim-daemons.sh", { detach = true })
	end,
	group = "stop-nvim-daemons",
})
