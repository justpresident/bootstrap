set tabstop=4
set shiftwidth=4
set smarttab

autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql softtabstop=4


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

syntax on
set autoindent
highlight Type term=underline ctermfg=1
highlight Statement term=bold ctermfg=7
highlight Constant term=underline ctermfg=3
highlight Special term=underline ctermfg=5
highlight Comment term=bold ctermfg=DarkGrey
highlight PreProc term=underline ctermfg=8
highlight LineNr ctermfg=DarkGrey

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

