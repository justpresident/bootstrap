" Set environment to 256 colours
set t_Co=256
set term=xterm-256color

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set nolist                        " show invisible characters
"set listchars=tab:>·,trail:·    " but only show tabs and trailing whitespace

filetype plugin indent on
syntax on

au BufNewFile,BufRead *.py set filetype=python
autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql softtabstop=4 list
autocmd BufEnter  *.pl,*.pm set list
autocmd BufEnter  *.go set nolist
autocmd BufNewFile,BufRead *.tt set ft=html

set nu
set wrap
set autoindent
set cindent

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

function ReloadTab()
    let tabpos = tabpagenr()
    execute 'silent! quit'
    execute 'silent! tab ball'
    execute 'silent! tabmove ' . (tabpos-1)
endfunction
command ReloadTab call ReloadTab()

map <C-a> <esc>ggVG<CR>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

:map <C-Up> mzMkzz`z
:map <C-Down> mzMjzz`z
:imap <C-Up> <ESC>mzMkzz`zi<Right>
:imap <C-Down> <ESC>mzMjzz`zi<Right>

nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" easy searching config
set path=.,,**
set wildmode=list:full
set wildignore=*.swp,*.bak
set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=tags
set wildignore+=*.tar.*
" nnoremap <leader>f :tabfind
" nnoremap <leader>F :tabfind <C-R>=expand('%:h').'/'<CR>

set tags=./tags;,tags;,~/b/main/tags;

set viminfo='10,\"100,:20,%,n~/.viminfo
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" work with buffers
nmap <leader>T :enew<cr>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

let g:airline_powerline_fonts = 1
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'V',
  \ 'V'  : 'V',
  \ '' : 'V',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ }

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='ubaryd'

function! AirlineInit()
    let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
endfunction

colorscheme italiano
autocmd VimEnter * call AirlineInit()

"set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_open_new_file = 't'
let g:ctrlp_user_command = {
\ 'types': {
  \ 1: ['.git', 'cd %s && git ls-files'],
  \ 2: ['.hg', 'hg --cwd %s locate -I .'],
  \ },
\ 'fallback': 'find %s -type f'
\ }
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
let g:ctrlp_working_path_mode = 'r'

let g:ctrlp_extensions=['tag']

function! Find(...)
    if a:0==2
        let path=a:1
        let query=a:2
    else
        let path="./"
        let query=a:1
    endif

    if !exists("g:FindIgnore")
        let ignore = ""
    else
        let ignore = " | egrep -v '".join(g:FindIgnore, "|")."'"
    endif

    let l:list=system("find ".path." -type f -path '".query."'".ignore)
    let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))

    if l:num < 1
        echo "'".query."' not found"
        return
    endif

    if l:num == 1
        exe "open " . substitute(l:list, "\n", "", "g")
    else
        let tmpfile = tempname()
        exe "redir! > " . tmpfile
        silent echon l:list
        redir END
        let old_efm = &efm
        set efm=%f

        if exists(":cgetfile")
            execute "silent! cgetfile " . tmpfile
        else
            execute "silent! cfile " . tmpfile
        endif

        let &efm = old_efm

        " Open the quickfix window below the current window
        botright copen

        call delete(tmpfile)
    endif
endfunction
command! -nargs=* Find :call Find(<f-args>)

map <C-/> <C-_> 

syn sync fromstart
execute pathogen#infect()
