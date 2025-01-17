" Things you should have installed first:
" git
" rg (ripgrep) or ag (silver-searcher)
" fzf (fuzzy finder)

let fzf_dir = system("which fzf")
set rtp+=$fzf_dir

" Enable syntax highlighting and indentation
syntax on
filetype plugin indent on

" Open splits to the bottom/right
set splitright
set splitbelow

" Package management

" Try to load minpac
silent! packadd minpac

" Attempt to automatically install minpac package manager via git if its
" directory doesn't exist
if !exists('g:loaded_minpac')
  let minpac_dir = $HOME . '/.vim/pack/minpac/opt'
  let minpac_install = 'git clone "https://github.com/k-takata/minpac.git" "' . minpac_dir . '/minpac"'

  echom('Unable to find minpac package manager. Creating ' . minpac_dir)
  call mkdir(minpac_dir, 'p')
  echom('Installing minpac with: ' . minpac_install)
  call system(minpac_install)
  echom('Reloading minpac')
  packadd minpac
endif

" Plugin initialization and installation
call minpac#init()

" Update package manager itself
call minpac#add('k-takata/minpac', {'type': 'opt'})

" General
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('altercation/vim-colors-solarized')
call minpac#add('tpope/vim-unimpaired') " Buffer/option toggling
call minpac#add('tpope/vim-obsession') " Session management
call minpac#add('tpope/vim-speeddating') " Better date incrementing
call minpac#add('mhinz/vim-grepper') " File search with ripgrep, ag, grep
call minpac#add('Raimondi/delimitMate') " Auto-close quotes/parens/brackets
call minpac#add('adelarsq/vim-matchit') " Better matching with '%'
call minpac#add('mattn/emmet-vim') " Expand CSS selector to HTML with <C-y>,
call minpac#add('scrooloose/nerdcommenter') " Easy commenting
call minpac#add('pbrisbin/vim-mkdir') " Ensure directory created before file save
call minpac#add('tpope/vim-abolish') " snake_case (crs) to MixedCase (crm) conversion
call minpac#add('tpope/vim-repeat') " Repeat macros/complex plugin commands
call minpac#add('tpope/vim-surround') " Surround objects with chars using motions (e.g. ysiw')
call minpac#add('marcweber/vim-addon-mw-utils') " required for snippets
call minpac#add('tomtom/tlib_vim') " required for snippets
call minpac#add('garbas/vim-snipmate') " snippets
call minpac#add('tpope/vim-endwise') " Intelligently add 'end' to blocks
call minpac#add('kana/vim-textobj-user') " Custom text objects
call minpac#add('glts/vim-magnum') " required for vim-radical
call minpac#add('glts/vim-radical') " Convert numbers to decimal, hex, octal, binary with cr[dxob]
call minpac#add('tpope/vim-dadbod') " DB client 
call minpac#add('kristijanhusak/vim-dadbod-ui') " DB UI client
call minpac#add('theniceboy/vim-calc') " calculator
call minpac#add('christoomey/vim-tmux-navigator') " easily navigate between vim and tmux

" Git
" TODO: Github plugin?
call minpac#add('tpope/vim-fugitive') " Git commands
" call minpac#add('airblade/vim-gitgutter') " Git status in left gutter
call minpac#add('tpope/vim-rhubarb') " GitHub stuff

" UI
call minpac#add('vim-airline/vim-airline') " Better status line
call minpac#add('vim-airline/vim-airline-themes') " Airline themes
call minpac#add('scrooloose/nerdtree') " File/directory tree
call minpac#add('unkiwii/vim-nerdtree-sync') " Sync NERDTree to current file
call minpac#add('jistr/vim-nerdtree-tabs') " NERDTree tabs

" Elixir
call minpac#add('elixir-editors/vim-elixir') " Elixir support
call minpac#add('carlosgaldino/elixir-snippets') " Elixir snippets
call minpac#add('andyl/vim-textobj-elixir') " Elixir block motion support
call minpac#add('slashmili/alchemist.vim')

" Call these with ':' to udpate/clean plugins
command! UpdatePackage call minpac#update()
command! CleanPackage call minpac#clean()

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
let mapleader=","
let maplocalleader="\\"

let g:snipMate = { 'snippet_version' : 1 }                                                                           

" Grepper config
let g:grepper = {}
let g:grepper.tools = ['rg', 'ag', 'grep']

" Tab-switching with Tab key in normal mode (requires vim-unimpaired)  
nmap <silent> <Tab> ]b
nmap <silent> <S-Tab> [b

" Save file(s)
nnoremap <silent> <leader>s :write<CR>
nnoremap <silent> <leader>S :wall<CR>
" Close file
nnoremap <silent> <leader>w :bdelete<CR>
" Force close file without saving
nnoremap <silent> <leader>W :bdelete!<CR>

" Unhighlight search
nnoremap <silent> <leader><leader> :nohlsearch<CR>

" Easy escape to normal mode. No english words contain 'jf', and they're
" typically the keys with raised bumps on them, so typing them without a bit
" of a delay between them in insert mode will escape out to normal mode.
inoremap jf <Esc><Esc>

" Don't outdent hashes
inoremap # #

" If fuzzy finder is installed, map Ctrl-P to a file finder
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~20%' }
if executable('fzf')
  nnoremap <C-p> :FzfFiles<CR>
endif

" Search for current word under cursor
nnoremap <Leader>f :Grepper<CR>
nnoremap <Leader>F :Grepper -cword -noprompt<CR>

" Search by motion (gf$, gfiw, gfa{, etc...)
nmap gf <plug>(GrepperOperator)
xmap gf <plug>(GrepperOperator)

" Alt + direction swaps windows
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" Make life easier by remapping ; to : for commands
nnoremap ; :
vnoremap ; :

" NERDCommenter settings
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" GitGutter settings
set signcolumn=yes
let g:gitgutter_highlight_lines=0

" Airline settings
let g:airline_theme='base16_3024'
let g:airline#extensions#tabline#enabled=1

" NERDTree settings
let NERDTreeIgnore=['vendor$', 'deps$', '.git$', '.svn$', '.hg$', '_build$', 'node_modules', 'schema_documentation']

let g:nerdtree_sync_cursorline=1
let g:NERDTreeHighlightCursorLine=1

let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_autofind=1

" Open file/directory tree sidebar
nmap <Leader>` <Plug>NERDTreeTabsToggle<CR><M-l>

" vim-surround mappings
nmap <silent> <leader>" cs'"
nmap <silent> <leader>' cs"'

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

nnoremap <leader>u yyp<S-v>r-<CR>
nnoremap <leader>U yyp<S-v>r=<CR>
nnoremap <leader>d "=strftime("%Y-%m-%d")<CR>p
nnoremap <leader>n :enew<CR>

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

let g:github_enterprise_urls = ['https://git.innova-partners.com']

" Elixir filetype not being set automatically in WSL
au BufRead,BufNewFile *.ex,*.exs set filetype=elixir
au BufRead,BufNewFile *.eex,*.heex,*.leex,*.sface,*.lexs set filetype=eelixir
au BufRead,BufNewFile mix.lock set filetype=elixir


:nmap <leader>p :let @+ = expand("%")<CR>
