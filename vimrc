
set nocompatible

" New leader key
let mapleader = ","

syntax enable
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nowrap
set autoindent
set smartindent

set nu
set showcmd
set foldmethod=indent
set foldcolumn=2
set foldlevel=30
set incsearch
"set hlsearch " highlight all matches
set cursorline
set bg=dark
set t_Co=256
"set mouse=a
"set mousemodel=popup
" default to UTF-8 encoding
set encoding=utf8
set fileencoding=utf8
set termencoding=utf-8
set mousehide

" enable visible whitespace
set list lcs=tab:\|\ ,trail:·,precedes:<,extends:>,nbsp:·
let c_space_errors = 1
let cpp_space_errors = 1

au BufRead,BufNewFile *.I set filetype=cpp
au BufRead SConstruct setfiletype python


" fix c++-lambda scope
hi link cErrInParen Normal
" no beep
autocmd VimEnter * set vb t_vb= 


""tabbar settings
let g:tagbar_left = 1
"autocmd FileType c,cpp,pl,py nested :TagbarOpen
autocmd VimEnter * nested :call tagbar#autoopen()
"autocmd FileType * nested :call tagbar#autoopen()
let g:tagbar_autofocus = 0
let g:tagbar_compact = 1
let g:tagbar_foldlevel = 1
let g:tagbar_sort = 0
"let g:tagbar_autoshowtag = 1

"Tag list settings
"let Tlist_Show_One_File = 1
"let Tlist_File_Fold_Auto_Close = 1
""let g:Tlist_GainFocus_On_ToggleOpen = 1
"let g:Tlist_Auto_Open = 1
""let g:Tlist_Auto_Highlight_Tag = 1
"let Tlist_Exit_OnlyWindow = 1

set tags+=~/.vim/systags
"set tags+=~/.vim/ctags.rust

imap >Ins> <Esc>i
"let xterm16_brightness='default'     " Change if needed 
"let xterm16_colormap='allblue'      " Change if needed 

set viminfo='10,\"100,:20,%,n~/.viminfo
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif


let g:molokai_original=0
"colo xterm16
"colo zenburn
colo molokai

function SMap(key, action, ...)
	let modes = " vi"
	if (a:0 > 0)
		let modes = a:{1}
	endif
	if (match(modes, '\Ii') != -1)
		execute 'imap ' . a:key . ' <Esc>' . a:action
	endif
	if (match(modes, '\Nn') != -1)
		execute 'nmap ' . a:key . ' <Esc>' . a:action
	endif
	if (match(modes, ' ') != -1)
		execute 'map ' . a:key . ' <Esc>' . a:action
	endif
	if (match(modes, '\Vv') != -1)
		execute 'vmap ' . a:key . ' <Esc>' . a:action
	endif
endfunction


" Use CTRL-F for omni completion
imap <C-F> <C-X><C-O>

" F11 - Tlist
"call SMap("<F11>", ":TlistToggle<cr>")
nmap <F11> :TagbarToggle<CR> 

" F10 to quick explorer
 call SMap("<F10>", ":Explore<cr>")


" Open tag under cursor in new tab
map <C-W>] <C-W>]:tab split<CR>gT:q<CR>gt

 map <F3> :vimgrep /FIXME\\|TODO/j *.[py,c,cc,pl]<CR>:cw<CR>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

nmap <Left> <<
nmap <Right> >>

vmap <Left> <gv
vmap <Right> >gv

nmap <Up> [e
nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv

nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j

" Tab autocompletion
"
function InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction


"imap <tab> <c-r>=InsertTabWrapper()<cr>

set complete=""
set complete+=.
set complete+=k
set complete+=b
set completeopt-=preview
set completeopt+=longest

