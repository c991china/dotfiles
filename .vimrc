" ~/.vimrc -- modest, no plugins required.
" Works in vim 8+ and neovim. If you want LSP, add coc.nvim separately;
" this is the config I want even on a box where I can't install anything.

set nocompatible
filetype plugin indent on
syntax on

" ---- sane defaults ----------------------------------------------------
set encoding=utf-8
set number
set relativenumber            " hybrid: absolute on current line, relative elsewhere
set ruler
set showcmd
set wildmenu
set wildmode=longest:full,full
set scrolloff=5               " keep 5 lines of context when scrolling
set sidescrolloff=8
set backspace=indent,eol,start
set hidden                    " switch buffers without saving; needed by lots of things
set noswapfile
set nobackup
set nowritebackup
set updatetime=300            " faster than the 4000ms default; matters for gitgutter etc.

" ---- search -----------------------------------------------------------
set incsearch
set hlsearch
set ignorecase
set smartcase                 " case-sensitive only if you type a capital
nnoremap <silent> <leader>h :nohlsearch<CR>

" ---- indentation (global default; filetype rules override) -------------
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set shiftround                " >> aligns to shiftwidth, not to next tab stop

" ---- per-filetype overrides -------------------------------------------
augroup filetype_overrides
    autocmd!
    autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2
    autocmd FileType javascript,typescript,html,css setlocal ts=2 sts=2 sw=2
    autocmd FileType python setlocal ts=4 sts=4 sw=4
    autocmd FileType make setlocal noexpandtab  " Makefiles need real tabs
    " jump to last edit position when reopening a file
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" | endif
augroup END

" ---- leader -----------------------------------------------------------
let mapleader = ","
let maplocalleader = "\\"

" ---- quality of life --------------------------------------------------
" j/k move by screen line, not file line (great for wrapped prose)
nnoremap j gj
nnoremap k gk

" Y yanks to end of line like C and D (default Y yanks the whole line)
nnoremap Y y$

" keep cursor centred on search jumps
nnoremap n nzzzv
nnoremap N Nzzzv

" <leader>w to save, <leader>q to quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" split navigation with ctrl-hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" reselect pasted text
nnoremap gp `[v`]

" ---- visual mode: stay in visual when indenting -----------------------
vnoremap < <gv
vnoremap > >gv

" ---- statusline (no plugins) ------------------------------------------
set laststatus=2
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ REPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#Visual#                    " reset colours
set statusline+=\ %f\ %h%m%r
set statusline+=%=
set statusline+=\ %y\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}]
set statusline+=\ %p%%
set statusline+=\ %l:%c\ 
