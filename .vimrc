" Set environment to 256 colours
set t_Co=256

set tabstop=4
set shiftwidth=4
set smarttab

filetype plugin indent on
syntax on

au BufNewFile,BufRead *.py set filetype=python
autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql softtabstop=4

au BufNewFile,BufRead *.pl,*.pm set filetype=perl


set wrap
set ai
set nu
set cin

set showmatch
set matchtime=1
set hlsearch
set incsearch
set ignorecase

set lz

set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

if !has('gui_running')
set mouse=
endif

set guioptions-=T
set guioptions-=m


set exrc
set backspace=2
set background=light

set autoindent

set swapsync=

function Diff()
w! %_vimdiff
!diff -up % %_vimdiff ; rm -f %_vimdiff
endfunction
command Diff call Diff()

function Sync()
syn sync fromstart
endfunction
command Sync call Sync()

function Koi8r()
e ++enc=koi8r
endfunction
command Koi8r call Koi8r()

function Utf8()
e ++enc=utf8
endfunction
command Utf8 call Utf8()

:map <C-Up> mzMkzz`z
:map <C-Down> mzMjzz`z
:imap <C-Up> <ESC>mzMkzz`zi<Right>
:imap <C-Down> <ESC>mzMjzz`zi<Right>

set viminfo='10,\"100,:20,%,n~/.viminfo
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

syn sync fromstart
