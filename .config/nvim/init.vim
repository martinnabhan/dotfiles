" install plug
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  auto VimEnter * PlugInstall
endif

" install ripgrep if fzf is installed
if !empty(glob("~/.fzf/bin/fzf"))
  if empty(glob("~/.fzf/bin/rg"))
    silent !curl -fLo /tmp/rg.tar.gz
      \ https://github.com/BurntSushi/ripgrep/releases/download/0.7.1/ripgrep-0.7.1-x86_64-apple-darwin.tar.gz
    silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
    silent !cp /tmp/ripgrep-0.7.1-x86_64-apple-darwin/rg ~/.fzf/bin/rg
  endif
endif

" plugins
call plug#begin('~/.vim/plugins')
  " fzf
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " theme
  Plug 'mhartington/oceanic-next'
  Plug 'trevordmiller/nova-vim'
  Plug 'vim-airline/vim-airline'
  Plug 'ryanoasis/vim-devicons'

  " utilities
  Plug 'scrooloose/nerdtree'
  Plug 'w0rp/ale'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " syntax highlight
  Plug 'sheerun/vim-polyglot'
call plug#end()

" enable indentation
filetype indent on

" show tabs as 2 spaces
set tabstop=2

" indent with 2 spaces
set shiftwidth=2
set expandtab

" indent php with 4 spaces
autocmd Filetype php setlocal ts=4 sw=4 sts=0 expandtab

" show line numbers
set number

" encoding
set encoding=utf8

" only redraw when necessary
set lazyredraw

" don't wrap long lines
set nowrap

" show search matches while typing
set showmatch

" disable mouse
set mouse=

" theme
syntax on 
set termguicolors
colorscheme nova
" colorscheme OceanicNext

let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
" let g:airline_theme='oceanicnext'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1

" nicer window borders
set fillchars+=vert:│

" keep buffers in memory
set hidden

" don't load gui
set guioptions=M

" undo, backup and swap
if empty(glob("~/.config/nvim/undo"))
  silent !mkdir ~/.config/nvim/undo
endif

if empty(glob("~/.config/nvim/backup"))
  silent !mkdir ~/.config/nvim/backup
endif

if empty(glob("~/.config/nvim/swap"))
  silent !mkdir ~/.config/nvim/swap
endif

set undodir=~/.config/nvim/undo//
set undofile
set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swap//

" navigate between buffers
nmap <C-k> :bnext<cr>
nmap <C-j> :bprevious<cr>

" delete buffer, keep split
nmap <C-d> :bp\|bd #<CR>

" delete buffer and split
nmap <C-g> :bdelete!<cr>

" enable esc to exit :terminal mode
tnoremap <Esc> <C-\><C-n>

" nerdtree settings and file highlight
nmap <C-n> :NERDTreeToggle<CR>
let NERDTreeMinimalUI=1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('xml', 'yellow', 'NONE', '#ab7967', 'NONE')
call NERDTreeHighlightFile('yml', 'yellow', 'NONE', '#ab7967', 'NONE')
call NERDTreeHighlightFile('yaml', 'yellow', 'NONE', '#ab7967', 'NONE')
call NERDTreeHighlightFile('config', 'yellow', 'NONE', '#ab7967', 'NONE')
call NERDTreeHighlightFile('conf', 'yellow', 'NONE', '#ab7967', 'NONE')
call NERDTreeHighlightFile('json', 'yellow', 'NONE', '#ab7967', 'NONE')
call NERDTreeHighlightFile('html', 'yellow', 'NONE', '#fac863', 'NONE')
call NERDTreeHighlightFile('css', 'cyan', 'NONE', '#99c794', 'NONE')
call NERDTreeHighlightFile('coffee', 'red', 'NONE', '#f99157', 'NONE')
call NERDTreeHighlightFile('js', 'red', 'NONE', '#f99157', 'NONE')
call NERDTreeHighlightFile('php', 'magenta', 'NONE', '#c594c5', 'NONE')
call NERDTreeHighlightFile('rb', 'red', 'NONE', '#ec5f67', 'NONE')

" fzf and rg keys
nmap <C-o> :Files<cr>
nmap <C-p> :Code<cr>

" customize fzf colors to match color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=* Code call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --color "always" --glob "!*.min.js" ' . shellescape(<q-args>), 1, <bang>0)

" open and reload files
command! Config e $MYVIMRC
command! Reload so $MYVIMRC
command! Profile e $HOME/.bash_profile
command! SSH e $HOME/.ssh/config

" add :bash shortcut for :terminal
command! Bash :terminal

" vim vue settings
let g:vue_disable_pre_processors=1
autocmd FileType vue syntax sync fromstart

" share vim and system clipboard
set clipboard=unnamed

" enable deocomplete autocompletions
let g:deoplete#enable_at_startup = 1

" bind tab for autocompletions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
