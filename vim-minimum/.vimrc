" =============================================================================
" Minimal Vim Configuration for Shared Servers
" Vim 8.2+ / No plugins required
" =============================================================================

" --- Encoding ---
set encoding=utf-8
set fileencodings=utf-8,sjis
scriptencoding utf-8

" --- Display ---
set number
set cursorline
set laststatus=2
set showcmd
set showmode
set wildmenu
set list
set listchars=tab:→\ ,space:·,trail:~,eol:↲

" --- Color (iceberg-like) ---
syntax enable
set background=dark
colorscheme desert

" UI
highlight Normal       ctermfg=252 ctermbg=NONE
highlight NonText      ctermfg=239
highlight SpecialKey   ctermfg=239
highlight CursorLine   cterm=NONE ctermbg=235
highlight CursorLineNr cterm=NONE ctermfg=110 ctermbg=235
highlight LineNr       ctermfg=239
highlight StatusLine   cterm=NONE ctermfg=245 ctermbg=234
highlight StatusLineNC cterm=NONE ctermfg=239 ctermbg=233
highlight VertSplit    ctermfg=239 ctermbg=NONE
highlight Pmenu        ctermfg=252 ctermbg=238
highlight PmenuSel     ctermfg=234 ctermbg=110
highlight Search       ctermfg=234 ctermbg=216
highlight Visual       ctermbg=236
highlight TabLine      cterm=NONE ctermfg=239 ctermbg=234
highlight TabLineFill  cterm=NONE ctermbg=233
highlight TabLineSel   cterm=NONE ctermfg=252 ctermbg=236
highlight MatchParen   ctermfg=216 ctermbg=239
highlight Folded       ctermfg=242 ctermbg=235
highlight DiffAdd      ctermbg=22
highlight DiffChange   ctermbg=236
highlight DiffDelete   ctermfg=174 ctermbg=52
highlight DiffText     ctermbg=24

" Syntax
highlight Comment      ctermfg=242
highlight Constant     ctermfg=140
highlight String       ctermfg=109
highlight Character    ctermfg=109
highlight Number       ctermfg=216
highlight Float        ctermfg=216
highlight Boolean      ctermfg=216
highlight Identifier   ctermfg=109
highlight Function     ctermfg=140
highlight Statement    ctermfg=110
highlight Keyword      ctermfg=110
highlight Conditional  ctermfg=110
highlight Repeat       ctermfg=110
highlight Operator     ctermfg=110
highlight PreProc      ctermfg=110
highlight Include      ctermfg=110
highlight Type         ctermfg=109
highlight Special      ctermfg=140
highlight Error        ctermfg=174 ctermbg=NONE
highlight Todo         ctermfg=216 ctermbg=NONE cterm=bold

" --- Cursor Shape ---
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" --- Indentation ---
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent
set smartindent

" --- Search ---
set ignorecase
set smartcase
set incsearch
set hlsearch

" --- Window ---
set splitright
set splitbelow

" --- Behavior ---
set noswapfile
set hidden
set backspace=indent,eol,start
set updatetime=100
set mouse=a
set clipboard=unnamedplus
set formatoptions=jql
set scrolloff=5
set sidescrolloff=5
set autoread
set confirm
set wildmode=longest:full,full
set history=1000
set nrformats-=octal

" --- Undo Persistence ---
if has('persistent_undo')
    let s:undodir = expand('~/.vim/undo')
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p')
    endif
    let &undodir = s:undodir
    set undofile
endif

" --- Cursor Position Restore ---
augroup restore_cursor
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \     execute "normal! g`\"" |
        \ endif
augroup END

" --- Auto Mkdir on Save ---
augroup auto_mkdir
    autocmd!
    autocmd BufWritePre *
        \ if !isdirectory(expand('%:p:h')) |
        \     call mkdir(expand('%:p:h'), 'p') |
        \ endif
augroup END

" --- Keymap ---
let mapleader = "\<Space>"

" Buffer navigation
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

" Yank to end of line
nnoremap Y y$

" Move by display line
nnoremap j gj
nnoremap k gk

" Emacs-like in insert mode
inoremap <C-a> <C-o>^
inoremap <C-e> <Esc>$i<Right>
inoremap <C-k> <Esc><Right>d$a

" Emacs-like in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Redo
nnoremap U <C-r>

" Indent without losing selection
nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv

" Clear search highlight
nnoremap <C-l> :<C-u>nohlsearch<CR><C-l>

" Search current word without jumping
nnoremap * *N

" Delete char without yanking
nnoremap x "_x

" Select all
nnoremap <Leader>a ggVG

" Replace word/selection with register
nnoremap <Leader>rep "_dw"+P
vnoremap <Leader>rep "_d"+P

" Open vertical split
nnoremap <C-w>n :vnew<CR>

" Close buffer
nnoremap <Leader>x :bprevious<CR>:bdelete #<CR>

" Substitute abbreviation: :s<Space> -> :%s///g
cnoreabbrev <expr> s getcmdtype() == ':' && getcmdline() == 's' ? '%s///g<Left><Left><Left>' : 's'
