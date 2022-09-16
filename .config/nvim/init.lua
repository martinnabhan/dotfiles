-- install packer if not installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.api.nvim_command("packadd packer.nvim")
end

vim.cmd("packadd packer.nvim")

require("packer").startup(function()
  use("akinsho/nvim-bufferline.lua")
  use("folke/lua-dev.nvim")
  use("hoob3rt/lualine.nvim")
  use("hrsh7th/nvim-compe")
  use("hrsh7th/vim-vsnip")
  use("lewis6991/impatient.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("junegunn/fzf")
  use("junegunn/fzf.vim")
  use("kyazdani42/nvim-tree.lua")
  use("kyazdani42/nvim-web-devicons")
  use("moll/vim-bbye")
  use("nathom/filetype.nvim")
  use("navarasu/onedark.nvim")
  use("neovim/nvim-lspconfig")
  use("nvim-lua/plenary.nvim")
  use("onsails/lspkind-nvim")
  use("pantharshit00/vim-prisma")
  use("rafamadriz/friendly-snippets")
  use("nvim-treesitter/nvim-treesitter")
  use("wbthomason/packer.nvim")
  use("williamboman/nvim-lsp-installer")
end)

require("impatient")

require("bufferline").setup({
  highlights = { buffer_selected = { guifg = "bg", gui = "NONE" } },
  options = {
    indicator_icon = "",
    max_name_length = 2000,
    offsets = { { filetype = "NvimTree", text = "", highlight = "Directory" } },
    separator_style = { "", "" },
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
})

require("compe").setup({ enabled = true, source = { buffer = true, nvim_lsp = true, vsnip = true } })
require("lspkind").init()

local onedark = require("lualine.themes.onedark")

onedark.normal.c.bg = "#282828"

require("lualine").setup({
  options = { component_separators = "|", globalstatus = 3, section_separators = "", theme = onedark },
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
  transparent = true,
})

require("onedark").load()

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.completion.spell,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.sqlformat,
  },
})

vim.diagnostic.config({
  virtual_text = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "additionalTextEdits", "detail", "documentation" },
}
capabilities.textDocument.formatting = false

require("nvim-lsp-installer").on_server_ready(function(server)
  local opts = {}

  if server.name == "sumneko_lua" then
    opts = require("lua-dev").setup({})
  end

  if server.name == "jsonls" or server.name == "tsserver" then
    opts.capabilities = capabilities
    opts.on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
    end
  end

  server:setup(opts)
end)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})


require("nvim-tree").setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    dotfiles = true,
  },
  renderer = {
    icons = {
      show = {
        git = false
      }
    },
    special_files = {},
  },
})

require("nvim-treesitter.configs").setup({
  highlight = { additional_vim_regex_highlighting = false, enable = true },
  indent = { enable = true },
})

_G.confirm = function()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
  end

  return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
end

_G.tab = function()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
  end

  return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
end

vim.api.nvim_set_keymap("n", "ga", ":lua vim.lsp.buf.code_action()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gn", ":lua vim.diagnostic.goto_next()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "gp", ":lua vim.diagnostic.goto_prev()<cr>", { silent = true })
vim.api.nvim_set_keymap("i", "<cr>", "compe#confirm('<cr>')", { expr = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-d>", ":Bdelete<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-g>", ":Bdelete!<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":lua vim.lsp.buf.hover()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-i>", ":Files<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":bprevious<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":bnext<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-o>", ":GitFiles<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", ":Code<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-t>", ":terminal<cr>i", { silent = true })
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { silent = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-p>", {})
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab()", { expr = true, silent = true })

vim.cmd("autocmd BufEnter * set fillchars=eob:\\ ")
vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float({ focusable = false })")
vim.cmd(
  'command! -bang -nargs=* Code call fzf#vim#grep("rg --column --trim --line-number --glob !package-lock.json --glob !yarn.lock --glob !.git --no-heading --hidden --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({ "options": "--delimiter : --nth 4.. --prompt \'検索(コード)> \'" }), <bang>0)'
)
vim.cmd(
  'command! -bang -nargs=* Files call fzf#run(fzf#wrap(fzf#vim#with_preview({ "options": "--multi --prompt \'検索> \'", "source": "fd --exclude .git --fixed-strings --hidden --no-ignore --type f" })))'
)
vim.cmd(
  'command! -bang -nargs=* GitFiles call fzf#run(fzf#wrap(fzf#vim#with_preview({ "options": "--multi --prompt \'検索(git)> \'", "source": "fd --exclude .git --fixed-strings --hidden --type f" })))'
)
vim.cmd("command! Bash :terminal")
vim.cmd("command! Config e $MYVIMRC")
vim.cmd("command! EslintFix !eslint_d --fix \"%\"")
vim.cmd("command! Profile e $HOME/.zshrc")
vim.cmd("command! Reload so $MYVIMRC")
vim.cmd("command! SSH e $HOME/.ssh/config")
vim.cmd("filetype indent on")
vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282828")
vim.cmd("highlight NvimTreeNormal guibg=#282828")

vim.fn.sign_define(
  "DiagnosticSignError",
  { texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" })
vim.fn.sign_define(
  "DiagnosticSignWarning",
  { texthl = "DiagnosticSignWarning", text = "", numhl = "DiagnosticSignWarning" }
)

vim.g.fzf_layout = { window = { width = 0.9, height = 0.9, border = "rounded" } }
vim.g.fzf_preview_window = { "right:50%", "ctrl-/" }

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  { virtual_text = false }
)

vim.o.clipboard = "unnamed"
vim.o.completeopt = "menuone,noselect"
vim.o.expandtab = true
vim.o.hidden = true
vim.o.scrollback = 100000
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "cI"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undodir = "/Users/martin/.config/nvim/undo/"
vim.o.undofile = true
vim.o.updatetime = 100

vim.wo.wrap = false

vim.api.nvim_command([[autocmd BufWritePre * lua vim.lsp.buf.format(nil, 10000)]])
