" Enable syntax highlighting and indentation
syntax on
filetype plugin indent on

augroup vimrc
  autocmd!
  " No undo files for /tmp directory, to prevent password manager caching
  autocmd BufWritePre /tmp/* setlocal noundofile
  " Reload .vimrc on write
  autocmd BufWritePost .vimrc source %
  " Remove trailing whitespace on save for Ruby/Elixir
  autocmd BufWritePre *.rb,*.ex,*.exs :%s/\s\+$//e
  " Wrap the quickfix window
  autocmd FileType qf setlocal wrap linebreak
augroup END

" Generic settings
set nowrap
set hidden " Allow multiple buffers at the same time
set nobackup
set noswapfile
set number
set fixeol
set scrolloff=10
set sidescrolloff=20
set shiftwidth=2
set tabstop=2
set softtabstop=2
set nowrap
set autoindent
set copyindent
set smartindent
set shiftround
set ignorecase
set smartcase
set smarttab
set expandtab
set hlsearch
set incsearch
set numberwidth=5
set laststatus=2
set history=1000
set undolevels=1000
set novisualbell
set noerrorbells
set clipboard^=unnamed,unnamedplus
set lazyredraw
set showmatch
set enc=utf-8
set cursorline
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]
set t_Co=256
set updatetime=100

silent !mkdir ~/.vim/undo > /dev/null 2>&1
set undodir=~/.vim/undo
set undofile

highlight Search cterm=None ctermfg=black ctermbg=white

" Mappings
let mapleader="<Space>"

nnoremap <silent> <C-s> :write<CR>
nnoremap <silent> <leader>bd :bdelete<CR>
nnoremap <silent> <leader>bw :bdelete!<CR>
nnoremap <leader>bn :enew<CR>

" Unhighlight search
nnoremap <silent> <leader><leader> :nohlsearch<CR>

" Easy escape to normal mode. No english words contain 'jf', and they're
" typically the keys with raised bumps on them, so typing them without a bit
" of a delay between them in insert mode will escape out to normal mode.
inoremap jf <Esc><Esc>

" Make life easier by remapping ; to : for commands
nnoremap ; :
vnoremap ; :

set background=light

" Session management
function! SaveSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . '/session.vim'

  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif

  exe "mksession! " . b:sessionfile
  echo "Session saved!"
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . '/session.vim'

  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" F5 will quick-save your current open files, F9 will reload them on a
" per-working-directory basis.
nnoremap <silent> <F5> :call SaveSession()<CR>
nnoremap <silent> <leader>5 :call SaveSession()<CR>
nnoremap <silent> <F9> :call LoadSession()<CR>
nnoremap <silent> <leader>9 :call LoadSession()<CR>

" CTRL + movement keys switches between windows in normal mode
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

:nmap <leader>p :let @+ = expand("%")<CR>
