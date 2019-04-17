if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  auto VimEnter * PlugInstall
endif

" install ripgrep if fzf is installed
if !empty(glob("~/.fzf/bin/fzf"))
  if empty(glob("~/.fzf/bin/rg"))
    if has('mac')
      silent !curl -fLo /tmp/rg.tar.gz
        \ https://github.com/BurntSushi/ripgrep/releases/download/11.0.0/ripgrep-11.0.0-x86_64-apple-darwin.tar.gz
      silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
      silent !cp /tmp/ripgrep-11.0.0-x86_64-apple-darwin/rg ~/.fzf/bin/
      silent !cp /tmp/ripgrep-11.0.0-x86_64-apple-darwin/complete/rg.bash /usr/local/etc/bash_completion.d/
    else
      silent !curl -fLo /tmp/rg.tar.gz
        \ https://github.com/BurntSushi/ripgrep/releases/download/11.0.0/ripgrep-11.0.0-x86_64-unknown-linux-musl.tar.gz
      silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
      silent !cp /tmp/ripgrep-11.0.0-x86_64-unknown-linux-musl/rg ~/.fzf/bin/rg
    endif
  endif

  if empty(glob("~/.fzf/bin/fd"))
    if has('mac')
      silent !curl -fLo /tmp/fd.tar.gz
        \ https://github.com/sharkdp/fd/releases/download/v7.3.0/fd-v7.3.0-x86_64-apple-darwin.tar.gz
      silent !tar xzvf /tmp/fd.tar.gz --directory /tmp
      silent !cp /tmp/fd-v7.3.0-x86_64-apple-darwin/fd ~/.fzf/bin/fd
      silent !cp /tmp/ripgrep-0.9.0-x86_64-apple-darwin/complete/rg.bash /usr/local/etc/bash_completion.d/
    else
      silent !curl -fLo /tmp/fd.tar.gz
        \ https://github.com/sharkdp/fd/releases/download/v7.3.0/fd-v7.3.0-x86_64-unknown-linux-musl.tar.gz
      silent !tar xzvf /tmp/fd.tar.gz --directory /tmp
      silent !cp /tmp/fd-v7.3.0-x86_64-unknown-linux-musl/fd ~/.fzf/bin/fd
    endif
  endif
endif

" plugins
call plug#begin('~/.vim/plugins')
  " fzf
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " theme
  Plug 'joshdick/onedark.vim'
  " Plug 'trevordmiller/nova-vim'
  " Plug 'dracula/vim', { 'as': 'dracula' }
  " Plug 'sonph/onehalf', {'rtp': 'vim/'}
  " Plug 'chriskempson/base16-vim'

  " lightline
  Plug 'itchyny/lightline.vim'
  Plug 'mgee/lightline-bufferline'
  Plug 'itchyny/vim-gitbranch'
  Plug 'maximbaz/lightline-ale'
  " Plug 'alnjxn/estilo-nova'
  " Plug 'daviesjamie/vim-base16-lightline'

  " devicons
  Plug 'ryanoasis/vim-devicons'

  " utilities
  Plug 'scrooloose/nerdtree'
  Plug 'martinn13/nerdtree-enter-new-tab'
  Plug 'w0rp/ale'
  Plug 'bfredl/nvim-miniyank'
  Plug 'moll/vim-bbye'

  " language servers
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
  Plug 'honza/vim-snippets'
  Plug 'tpope/vim-markdown'

  " syntax highlighting
  Plug 'herringtondarkholme/yats.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'jparise/vim-graphql'
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
autocmd Filetype blade setlocal ts=2 sw=2 sts=0 expandtab

" show line numbers
set nonumber

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

let g:onedark_terminal_italics = 1
let g:onedark_color_overrides = {
\ "black": {"gui": "#1e1e1e", "cterm": "235", "cterm16": "0" },
\}

colorscheme onedark

" colorscheme nova
" colorscheme dracula
" colorscheme onehalfdark
" colorscheme base16-twilight
" let base16colorspace=256  " Access colors present in 256 colorspace

" lightline
set showtabline=0
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

let g:lightline = {}
let g:lightline.colorscheme = 'onedark'

" let g:lightline.colorscheme = 'base16'
" let g:lightline.colorscheme = 'nova'
" let g:lightline.colorscheme = 'Dracula'
" let g:lightline.colorscheme = 'onehalfdark'

let g:lightline.active = {
\  'left': [
\    ['mode', 'paste'], ['buffers']
\  ],
\  'right': [
\    ['cocstatus', 'filetype', 'fileencoding', 'fileformat', 'percent', 'lineinfo', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok']
\  ]
\}

let g:lightline.tabline = {
\  'left': [
\    ['buffers']
\  ],
\  'right': [
\    []
\  ],
\}

let g:lightline.component_expand = {
\  'buffers': 'lightline#bufferline#buffers',
\  'linter_checking': 'lightline#ale#checking',
\  'linter_warnings': 'lightline#ale#warnings',
\  'linter_errors': 'lightline#ale#errors',
\  'linter_ok': 'lightline#ale#ok',
\}

let g:lightline.component_function = {
\  'gitbranch': 'gitbranch#name',
\  'filetype': 'WebDevIconsGetFileTypeSymbol',
\  'fileformat': 'WebDevIconsGetFileFormatSymbol',
\  'cocstatus': 'coc#status',
\}

let g:lightline.component_type = {
\  'buffers': 'tabsel',
\  'linter_checking': 'left',
\  'linter_warnings': 'warning',
\  'linter_errors': 'error',
\  'linter_ok': 'left',
\}

let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#unnamed = ''

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c"

" hide intro message
set shortmess=I

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
nmap <C-d> :Bdelete<cr>:call lightline#update()<cr>

" force delete buffer, keep split
nmap <C-g> :Bdelete!<cr>:call lightline#update()<cr>

" enable esc to exit :terminal mode
tnoremap <Esc> <C-\><C-n>

" nerdtree settings and file highlight
nmap <C-n> :NERDTreeToggle<cr>
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
call NERDTreeHighlightFile('typescript', 'red', 'NONE', '#a2ca84', 'NONE')
call NERDTreeHighlightFile('tsx', 'red', 'NONE', '#a2ca84', 'NONE')
call NERDTreeHighlightFile('ts', 'red', 'NONE', '#f99157', 'NONE')

" fzf and rg keys
nmap <C-i> :Files<cr>
nmap <C-o> :GitFiles<cr>
nmap <C-p> :Code<cr>

command! -bang -nargs=* Files call fzf#run(fzf#vim#with_preview(fzf#wrap({'source': 'fd --type f --hidden --no-ignore', 'sink': 'e', 'down': '70%'})))
command! -bang -nargs=* GitFiles call fzf#run(fzf#vim#with_preview(fzf#wrap({'source': 'fd --type f', 'sink': 'e', 'down': '70%'})))
command! -bang -nargs=* Code call fzf#vim#grep('rg --column --fixed-strings --no-heading --ignore-case --line-number -g "!*.min.js" -g "!*.lock" -g "!package-lock.json" -g "!vendor.js" ' . shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%'))

" open and reload files
command! Config e $MYVIMRC
command! Reload so $MYVIMRC
command! Profile e $HOME/.zshrc
command! SSH e $HOME/.ssh/config

" add :Bash shortcut for :terminal
command! Bash :terminal

" set terminal emulator scrollback to 100,000
set scrollback=100000

" share vim and system clipboard
set clipboard=unnamed

" hide ugly end of buffer ~
 hi EndOfBuffer guibg=#1e1e1e guifg=#1e1e1e

" miniyank settings
let g:miniyank_maxitems = 500

if empty(glob("~/.config/nvim/.miniyank.mpack"))
  silent !touch ~/.config/nvim/.miniyank.mpack
endif

let g:miniyank_filename = $HOME . "/.config/nvim/.miniyank.mpack"

" miniyank/fzf integration
function! FZFYankList() abort
  function! KeyValue(key, val)
    let line = join(a:val[0], '\n')

    if (a:val[1] ==# 'V')
      let line = '\n'.line
    endif

    return a:key.' '.line
  endfunction

  return map(miniyank#read(), function('KeyValue'))
endfunction

function! FZFYankHandler(opt, line) abort
  let key = substitute(a:line, ' .*', '', '')

  if !empty(a:line)
    let yanks = miniyank#read()[key]
    call miniyank#drop(yanks, a:opt)
  endif
endfunction

command! Yanks call fzf#run(fzf#wrap('YanksAfter', {
\ 'source':  FZFYankList(),
\ 'sink':    function('FZFYankHandler', ['p']),
\ 'options': '--no-sort --prompt="> "',
\ }))

nmap <C-u> :Yanks<cr>

" ale
let g:ale_lint_delay = 1000

" fix syntax highlighting on long files
autocmd BufEnter * :syntax sync fromstart

" use <tab> for completions
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" use <Tab> and <S-Tab> to navigate completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" increase cmdheight
set cmdheight=2

" shorter updatetime for cursor hold
set updatetime=300

" show type definition on cursor hold
autocmd CursorHold * silent call CocActionAsync('doHover')

" highlight coc.nvim popups
let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'typescript']
