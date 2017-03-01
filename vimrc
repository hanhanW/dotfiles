"vim-plug {{{
call plug#begin('~/.vim/plugged')

Plug 'hanhanW/molokai'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'Valloric/YouCompleteMe'
Plug 'junegunn/fzf.vim'
Plug 'vim-ruby/vim-ruby'

call plug#end()
" }}}

filetype indent plugin on

syntax on
set autoread                
set autoindent                  " (ai) turn on auto-indenting (great for programers)
set showmatch                   " (sm) briefly jump to matching bracket when inserting one
set number                      " (nu) show line numbers
set ruler                       " (ru) show the cursor position at all times
set incsearch                   " (is) highlights what you are searching for as you type
set hlsearch                    " (hls) highlights all instances of the last searched string
set ignorecase                  " (ic) ignores case in search patterns 
set smartcase                   " (scs) don't ignore case when the search pattern has uppercase
set showcmd                     " (sc) display an incomplete command in the lower right
set history=10000
set nowrap
set expandtab
set mouse=a
set backspace=indent,eol,start
set shiftwidth=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set laststatus=2
set textwidth=100               " (tw) number of columns before an automatic line break is inserted
                                " (see formatoptions)
set colorcolumn=+1
set fileencodings=utf8
set encoding=utf8

" Move swap/undo files. {{{
" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo,
  " then .
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undodir+=.
  set undofile
endif
" }}}

" => Map leader settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 "Set map leader to " "
let mapleader = " "
let maplocalleader = " "
let g:mapleader = " "
let g:maplocalleader = " "
runtime .vimrc_leader
" }}}

" auto reload vimrc
autocmd! bufwritepost .vimrc source %

highlight Normal ctermbg=None

"autocmd BufNewFile *.cpp 0r ~/Templates/default.cpp
"autocmd BufNewFile *.rb 0r ~/Templates/default.rb

autocmd FileType Makefile setlocal noexpandtab
autocmd FileType cpp se makeprg=g++\ -g\ -Wall\ -Wshadow\ -O2\ -std=c++14\ -DDARKHH\ -o\ %<\ %
autocmd FileType c se makeprg=gcc\ -g\ -Wall\ -Wshadow\ -O2\ -std=c11\ -o\ %<\ %
autocmd FileType tex se syntax=tex makeprg=xelatex\ -interaction=nonstopmode\ %
autocmd FileType tex let g:indentLine_enabled=0
autocmd FileType json let g:indentLine_enabled=0

set foldmarker={{{,}}}
set foldmethod=marker
set foldlevel=0
set foldnestmax=3

function! QFSwitch()
    redir => ls_output
    execute ':silent! ls'
    redir END

    let exists = match(ls_output, "[Quickfix List")
    if exists == -1
        execute ':copen'
    else
        execute ':cclose'
    endif
endfunction
func! Exc()
	let curr_file = expand('%:e')
	if curr_file == "c" || curr_file == "cpp" || curr_file == "hs"
		exec "!./%<"
	elseif curr_file == "py"
		exec ":w"
		exec "! python3 %"
	elseif curr_file == "tex"
		exec "silent ! evince %<.pdf > /dev/null 2>&1 &"
		exec ":redraw!"
  elseif curr_file == "rb"
    exec ":w"
    exec "! ruby %"
	endif
endfunc

func! Exc_with_fin()
	exec "!./%< < %<.in"
endfunc

if $TERM =~ '^screen-256color'
    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>
endif

nnoremap <F7> <ESC>:wa<CR>:mak<CR>
imap <F7> <ESC>:wa<CR>:mak<CR>
nnoremap <F8> :call QFSwitch()<CR>
nnoremap <F9> :call Exc()<CR>
nmap <Tab> :tabnext<CR>
nmap <S-Tab> :tabprev<CR>
cmap w!! w !sudo tee % > /dev/null

" --- NERD Commenter plugin --- {{{
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 0
map <leader>cc <plug>NERDCommenterComment
map <leader>cu <plug>NERDCommenterUncomment
map <leader>c<space> <plug>NERDCommenterToggle
" }}}

" --- YCM plugin --- {{{
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview 
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<S-TAB>']
" }}}

inoremap <expr> <Down> pumvisible() ? "\<C-E>\<Down>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-E>\<Up>" : "\<Up>"

let g:indentLine_char = "│"

let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

if filereadable( expand("$HOME/.vim/plugged/molokai/colors/molokai.vim") )
  colorscheme molokai
endif
