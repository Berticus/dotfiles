"set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
set t_Co=256
" colorscheme xoria256
" Some themes are only for gvim, not vim
if (&t_Co == 256 || &t_Co == 88) && !has('gui_running') &&
            \ filereadable(expand("$HOME/.vim/plugin/guicolorscheme.vim"))
    runtime! plugin/guicolorscheme.vim
    GuiColorScheme tnb-mod
else
    colorscheme tnb-mod
endif

set enc=utf-8

set history=1000

set acd " autochdir

syntax on " Enable syntax highlighting
filetype plugin indent on " Enable filetype detection, plugins, and indentation

set hidden " allow hidden buffers
runtime macros/matchit.vim
set wildmenu
set wildmode=list:longest,full

set backupdir=~/.local/share/vim
set directory=~/.local/share/vim
set nobackup
set nowb
set noswapfile

set nocompatible
set mouse=r " Let the mouse work in the console
set showmatch
set ruler " Always show cursor
set cursorline

" This uses relativenumber for all lines except the current one
set relativenumber
set number

" display current mode and partially typed commands
set showmode
set showcmd

" case-insensitive searches, unless caps are involved
set ignorecase
set smartcase

set foldmethod=manual
set foldlevel=99

set shortmess=atI

set autoread

set equalalways

set magic
set so=7

set splitright

set clipboard=unnamed

" tabs -> spaces
" default 4-space dd
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
set cindent
set smartindent
set autoindent

set hls
set incsearch

highlight Pmenu ctermbg=238 gui=bold

" textwidth limits
autocmd! BufRead /tmp/mutt-* set tw=72 " mutt limit to 72 characters
"autocmd BufRead *.txt set tw=78 " text files limit to 78 characters

" vertical line at 80th column
"highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
set colorcolumn=80

" java-specific
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1

let g:tex_flavor="pdflatex"
"let g:tex_flavor="latex"

let g:GPGUseAgent=0
let g:GPGPrefArmor=1
let g:GPGDefaultRecipients=["Albert Chang <albert.chang@gmx.com>"]

let g:NERDTreeWinSize = 100

" NERDTree
map <F2> :silent NERDTreeToggle<CR>

set pastetoggle=<leader>p

set confirm

let g:ConqueTerm_PyVersion = 3
let g:ConqueTerm_FastMode = 0
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_CloseOnEnd = 0

" omnicompletion
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,menu,longest,preview
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

set listchars=tab:>-,trail:·,eol:$
set list
nmap <silent> <leader>s :set nolist!<CR>

" autorun files
set autowrite
command! -buffer W make
command! -buffer Hex set binary | %!xxd
command! -buffer UHex %!xxd -r | set nobinary

" when ~/.vimrc is changed, autoload
autocmd! BufWritePost .vimrc source %

" I use /tmp/msg* for e-mail
" *.eml for when thunderbird works
autocmd! BufNewFile,BufRead /tmp/msg* set colorcolumn=72
autocmd! BufNewFile,BufRead *.eml set colorcolumn=72

" arduino syntax highlighting
autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino

" indentation & write + load
autocmd! FileType ruby set shiftwidth=2 softtabstop=2 tabstop=2 makeprg=ruby\ %
autocmd! FileType python set shiftwidth=4 softtabstop=4 tabstop=4 makeprg=python\ %
autocmd! FileType perl set shiftwidth=4 softtabstop=4 tabstop=4 makeprg=perl\ %
autocmd! FileType java set shiftwidth=4 softtabstop=4 tabstop=4 makeprg=javac\ %
autocmd! FileType lua set shiftwidth=4 softtabstop=4 tabstop=4 makeprg=lua\ %
autocmd! FileType tex set shiftwidth=4 softtabstop=4 tabstop=4 makeprg=pdflatex\ %
autocmd! FileType c,cpp set shiftwidth=4 softtabstop=4 tabstop=4 makeprg=make
autocmd! FileType sh set shiftwidth=2 softtabstop=2 tabstop=2 makeprg=./%
autocmd! BufNewFile,BufRead PKGBUILD set shiftwidth=2 softtabstop=2 tabstop=2 makeprg=makepkg
autocmd! FileType eml set colorcolumn=72

" indentation only
" no indentation
autocmd! FileType asciidoc set nocindent noautoindent
" 4-space explicit
autocmd! FileType javascript,arduino,php,html,xhtml,css,xml set shiftwidth=4 softtabstop=4 tabstop=4
" 2-space
autocmd! FileType vhdl set shiftwidth=2 softtabstop=2 tabstop=2
" 8-space

" auto-chmod
autocmd! BufWritePost * call NoExtNewFile()

function! NoExtNewFile()
    if getline(1) =~ "^#!.*/bin/"
        if &filetype == ""
            filetype detect
        endif
        silent !chmod a+x <afile>
    endif
endfunction

" use templates
autocmd! BufNewFile * call LoadTemplate()
" jump between %VAR% placeholders in Insert mode with <Ctrl-p>
inoremap <C-p> <ESC>/%\u.\{-1,}%<cr>c/%/e<cr>

function! LoadTemplate()
    silent! 0r ~/.vim/skel/tmpl.%:e

    " Highlight %VAR% placeholders with the Todo color group
    syn match Todo "%\u\+%" containedIn=ALL
endfunction

" Highlight a column in csv text.
" :Csv 1    " highlight first column
" :Csv 12   " highlight twelfth column
" :Csv 0    " switch off highlight
function! CSVH(colnr)
  if a:colnr > 1
    let n = a:colnr - 1
    execute 'match Keyword /^\([^,]*,\)\{'.n.'}\zs[^,]*/'
    execute 'normal! 0'.n.'f,'
  elseif a:colnr == 1
    match Keyword /^[^,]*/
    normal! 0
  else
    match
  endif
endfunction
command! -nargs=1 Csv :call CSVH(<args>)
