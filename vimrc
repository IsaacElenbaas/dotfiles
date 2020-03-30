" plugins will be downloaded under the specified directory
call plug#begin('~/.vim/plugged')
" declare the list of plugins
Plug 'tpope/vim-sensible'
Plug 'ntpeters/vim-better-whitespace'
Plug 'itchyny/lightline.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
Plug 'terryma/vim-expand-region'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'kshenoy/vim-signature'
Plug 'dylanaraps/fff.vim'
call plug#end()
let g:rainbow_active=1
let g:fff#split="20new"
" end plugin setup
" use 256 color
set t_Co=256

" https://tedlogan.com/techblog3.html

" copy indent chars when hitting enter at end of indented line
set copyindent
" hard/soft tab display widths
set tabstop=2
set softtabstop=2
" automatic indentation total width, doesn't affect characters
set shiftwidth=2
" stupid, vim-sensible enables it
set nosmarttab
" number rows
set number
" don't show mode on command line
set noshowmode
" allow going to end of line in normal mode
set virtualedit+=onemore
" highlight all matches when searching
set hlsearch
" leading whitespace highlighting
set listchars=tab:\|\ ,space:·
highlight SpecialKey ctermfg=black
highlight LeadingWhitespace ctermfg=white
call matchadd('LeadingWhitespace', '^\s\+')
set list
" end leading whitespace highlighting
" do : then Ctrl+k then a key to see what it is to vim (eg. <End> is <kEnd> for some reason)
nmap <kEnd> $<Right>
nmap Q :
nmap q :q<CR>
nmap f :F<CR>
nmap h <Nop>
nmap j <Nop>
nmap k <Nop>
nmap l <Nop>
" window management
nmap <c-h> <c-w>h
nmap <c-t> <c-w>j
nmap <c-c> <c-w>k
nmap <c-n> <c-w>l
nnoremap p P
nnoremap P p

autocmd InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

