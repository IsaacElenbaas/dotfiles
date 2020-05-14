"{{{ plugins
	"{{{ plugin installation
" :PlugInstall :PlugClean :PlugUpdate :PlugUpdate
call plug#begin('~/.vim/plugged')
Plug 'chaoren/vim-wordmotion'
Plug 'dstein64/vim-startuptime'
Plug 'dylanaraps/fff.vim'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kshenoy/vim-signature'
Plug 'machakann/vim-sandwich'
Plug 'mbbill/undotree'
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'terryma/vim-expand-region'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'SirVer/ultisnips'
call plug#end()
	"}}}

	"{{{ plugin config
" vim-wordmotion
nnoremap s w
xnoremap s w
onoremap s w
xnoremap is iw
onoremap is iw
xnoremap as aw
onoremap as aw
" fff
let g:fff#split="20new"
" vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" vim-expand-region
call expand_region#custom_text_objects({"is" :0,"if" :0})
" quick-scope
let g:qs_second_highlight=0
augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary term=NONE cterm=NONE ctermfg=NONE ctermbg=240 gui=NONE guifg=NONE guifg=NONE guibg=NONE
augroup END
" ultisnips
let g:UltiSnipsSnippetDirectories=["/home/isaacelenbaas/.vim/Ultisnips", "/home/isaacelenbaas/.vim/MyUltiSnips"]
" couldn't find a way to unbind these and I don't have F keys on my keyboard
let g:UltiSnipsExpandTrigger="<F1>"
let g:UltiSnipsJumpForwardTrigger="<F1>"
let g:UltiSnipsJumpBackwardTrigger="<F1>"
let g:ulti_expand_or_jump_res=0
function! Ulti_ExpandOrJump_getRes()
	call UltiSnips#ExpandSnippetOrJump()
	return g:ulti_expand_or_jump_res
endfunction
" has to be <c-r>=, not sure why
inoremap <silent> <Space> <c-r>=(Ulti_ExpandOrJump_getRes() > 0) ? "\<lt>Left>" : "\<lt>Space>" <CR>
xnoremap <silent> m di\`<c-r>"\`<Esc>
nnoremap <silent> mm 0vg_di\`<c-r>"\`<Esc>
	"}}}
"}}}

"{{{ functions
	"{{{ ScrollPercent
" for scrolling to visible percentage when there are folds
function ScrollPercent(percent)
	normal! G
	let l:i=0
	while line(".") > 1
		execute "normal! " . (1+line("$")/1000) . "k"
		let i+=1+line('$')/1000
	endwhile
	execute "normal! " . a:percent*l:i/100 . "j"
endfunction
	"}}}

	"{{{ ToggleAllFolds
function ToggleAllFolds()
	let l:position=line(".")
	normal! G
	execute "normal! " . (line("$")-2) . "k"
	execute "normal! " . ((line(".") == 1) ? "zR" : "zM")
	execute "normal! " . l:position . "gg"
endfunction
	"}}}

	"{{{ SynGroup
function SynGroup()
	let l:s=synID(line("."), col("."), 1)
	echo synIDattr(l:s, "name") . ' -> ' . synIDattr(synIDtrans(l:s), "name")
endfunction
	"}}}

"{{{ SelectFold
function SelectFold(around)
	let l:position=line(".")
	if foldclosed(l:position) == -1
		normal! za
		let l:start=foldclosed(l:position)
		if l:start == -1
			return
		endif
		let l:end=foldclosedend(l:position)
		execute "normal! za" . (l:start+((a:around) ? 0 : 1)) . "GV" . (l:end-((a:around) ? 0 : 1)) . "G"
	else
		execute "normal! V"
	endif
endfunction
"}}}
"}}}

"{{{ settings
" use 256 color
set t_Co=256
" hybrid number rows
set number
set relativenumber
" don't show mode on command line
set noshowmode
" allow going to end of line in normal mode
set virtualedit+=onemore
" highlight all matches when searching
set hlsearch
" replace global by default
set gdefault
" don't timeout multi-stroke mappings
set notimeout
" enable fold markers
set foldmethod=marker
" scroll through history
set mouse=n
nnoremap <ScrollWheelDown> u
nnoremap <ScrollWheelUp> <c-r>
	"{{{ indentation
" https://tedlogan.com/techblog3.html
" copy indent chars when hitting enter at end of indented line
set copyindent
" hard/soft tab display widths
set tabstop=2
set softtabstop=2
" automatic indentation total width, doesn't affect characters
set shiftwidth=2
runtime! plugin/sensible.vim
" stupid, vim-sensible enables it
set nosmarttab
" part of cursor fixes
filetype indent off
	"}}}
"}}}

"{{{ mappings
" do : then Ctrl+k then a key to see what it is to vim (eg. <End> is <kEnd> for some reason)
" :verbose map key to see what binds begin with a key
" can't use <c-o> because of autocmd cursor fix, use <Esc>...i

	"{{{ commands
cmap w!! w !sudo tee > /dev/null %
command D w !git diff --no-index -- % -
command M silent make<bar>call feedkeys("\<lt>CR>", "n")
	"}}}

nnoremap Q :
nnoremap q :<c-u>q<CR>
nnoremap p P
nnoremap P p
vnoremap <expr> p (mode() == "\<c-v>") ? 'I<c-r>"' : "p"
nnoremap x "_d
nnoremap xx "_dd
nnoremap X "_D
nnoremap dD ^D
nnoremap Y y$
" ctrl+backspace
inoremap  <Esc>dbi
" folds
nnoremap <Space> za
nnoremap z<Space> :<c-u>call ToggleAllFolds()<CR>
" clear searches
nnoremap <silent> <Leader>/ :<c-u>let @/=""<CR>
xnoremap <silent> if :<c-u>call SelectFold(0)<CR>
onoremap <silent> if :<c-u>call SelectFold(0)<CR>
xnoremap <silent> af :<c-u>call SelectFold(1)<CR>
onoremap <silent> af :<c-u>call SelectFold(1)<CR>
nmap h <Plug>(expand_region_expand)
xmap h <Plug>(expand_region_expand)
nnoremap j J
xmap t <Plug>(expand_region_shrink)

	"{{{ basic movement
nnoremap <Tab> %
nnoremap $ g$
nnoremap <kHome> g^
nnoremap <kEnd> g$
imap <kHome> <Esc><kHome>i
imap <kEnd> <Esc><kEnd>i
nnoremap k <Nop>
nnoremap l <Nop>
" soft lines
nnoremap <Down> gj
nnoremap <Up> gk
xnoremap <Down> gj
xnoremap <Up> gk
inoremap <Down> <Esc>gji
inoremap <Up> <Esc>gki
	"}}}

	"{{{ travelling
nnoremap tm '
xnoremap tm '
" back/forward in jump history
nnoremap tb <c-o>
nnoremap tf <c-i>
" up/down 1/2 page
nnoremap <silent> tu :<c-u>mark `<CR><c-u>``
nnoremap <silent> td :<c-u>mark `<CR><c-d>``
" go to definition
nnoremap tD gd
" keyrepeat
nnoremap tmm <Nop>
nmap <silent> tn :<c-u>call signature#mark#Goto("next", "spot", "pos")<CR>tmm
nmap <silent> tN :<c-u>call signature#mark#Goto("prev", "spot", "pos")<CR>tmm
nmap <silent> t<Down> :<c-u>execute "normal! 2\<lt>c-e>"<CR>Mtmm
nmap <silent> t<Up> :<c-u>execute "normal! 2\<lt>c-y>"<CR>Mtmm
nmap tt t<Down>
nmap tc t<Up>
nmap tmmn tn
nmap tmmN tN
nmap tmmt tt
nmap tmmc tc
nmap tmm<Down> t<Down>
nmap tmm<Up> t<Up>
	"}}}

	"{{{ enclosing characters
inoremap () ()<Left>
inoremap (); ();
inoremap ()<Space> ()<Space>
inoremap ()<CR> ()<CR>
xnoremap ( di(<c-r>")<Esc>
xmap ) (

inoremap [] []<Left>
inoremap []<Space> []<Space>
inoremap []<CR> []<CR>
imap [) []
xnoremap [ di[<c-r>"]<Esc>
xmap ] [

inoremap <> <><Left>
inoremap <><Space> <><Space>
inoremap <><CR> <><CR>

inoremap "" ""<Left>
inoremap ""<Space> ""<Space>
inoremap ""<CR> ""<CR>
imap "' ""
xnoremap " di"<c-r>""<Esc>

inoremap '' ''<Left>
inoremap ''<Space> ''<Space>
inoremap ''<CR> ''<CR>
xnoremap ' di'<c-r>"'<Esc>

inoremap `` ``<Left>
inoremap ``<Space> ``<Space>
inoremap ``<CR> ``<CR>
xnoremap ` di`<c-r>"`<Esc>

" makes <expr> below not happen
inoremap {} {}
inoremap {}<Space> {<Space><Space>}<Left><Left>
imap {) {}
" turns (stuff {) into (stuff) {<CR><CR>} ending on empty line
inoremap <silent> <expr> {<CR> ((strlen(getline(".")) == getpos(".")[2]-1) ? "" : "<BS><kEnd><Space>") . "{<CR>t<CR>}<Up><BS>"
xnoremap { di{<c-r>"}<Esc>
xmap } {
	"}}}

	"{{{ scrolling to percentage
nnoremap ss gg
nnoremap <silent> s1 :<c-u>call ScrollPercent(10)<CR>
nnoremap <silent> s2 :<c-u>call ScrollPercent(20)<CR>
nnoremap <silent> s3 :<c-u>call ScrollPercent(30)<CR>
nnoremap <silent> s4 :<c-u>call ScrollPercent(40)<CR>
nnoremap <silent> s5 :<c-u>call ScrollPercent(50)<CR>
nnoremap <silent> s6 :<c-u>call ScrollPercent(60)<CR>
nnoremap <silent> s7 :<c-u>call ScrollPercent(70)<CR>
nnoremap <silent> s8 :<c-u>call ScrollPercent(80)<CR>
nnoremap <silent> s9 :<c-u>call ScrollPercent(90)<CR>
nnoremap s0 G
	"}}}

	"{{{ window management
nnoremap <c-h> <c-w>h
nnoremap <c-t> <c-w>j
nnoremap <c-c> <c-w>k
nnoremap <c-n> <c-w>l
nnoremap <c-m> <c-w>s
nnoremap <c-s> <c-w>v
nnoremap <c-o> <c-w>5<
nnoremap <c-e> <c-w>5-
nnoremap <c-.> <c-w>5+
nnoremap <c-u> <c-w>5>
	"}}}
"}}}

"{{{ theming
colorscheme myColors

	"{{{ folding
		"{{{ fold text
function! FoldText()
	let l:label="{{" . "{ " . substitute(getline(v:foldstart), '.*{{' . '{\s*', '', "") . " }" . "}}"
	" +2 chars at beginning makes it more obvious when something is opened
	return repeat("-", v:foldlevel*2+2) . l:label . repeat(" ", winwidth(0))
endfunction
set foldtext=FoldText()
		"}}}

		"{{{ fold markers
hi link FoldMarker Folded
hi FoldMarkerSpace ctermfg=8 ctermbg=8
augroup FoldMarkerHighlight
	autocmd!
	" this horrible regex is to color fold markers - only in comments
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1) | call matchadd("FoldMarker", '\V' . (substitute(&commentstring, '%s', '\\m.*\\%({{{\\|}}}\\).*\\V', ""))) | endif
	" spaces immediately before/after comment chars
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1) | call matchadd("FoldMarkerSpace", '\s\+\%(\V' . (substitute(&commentstring, '%s', '\\m\\s*\\%({{{\\|}}}\\)\\)\\@=\\V', ""))) | endif
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1) | call matchadd("FoldMarkerSpace", '\%(\V' . (substitute(&commentstring, '%s', '\\m\\)\\@<=\\s\\+\\%({{{\\|}}}\\)\\@=\\V', ""))) | endif
	" spaces after fold marks
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1) | call matchadd("FoldMarkerSpace", '\%(\V' . (substitute(&commentstring, '%s', '\\m\\s*\\%({{{\\|}}}\\).*\\)\\@<=\\s\\+\\V', ""))) | endif
augroup end
		"}}}
	"}}}

	"{{{ leading and bad whitespace
set list
set listchars=tab:\|\ ,space:·
" hides listchars for non-leading whitespace (as best as possible, BG doesn't
" seem to be referenceable and 0 is as close as you can get without hardcoding
highlight NormalWhitespace ctermfg=0
call matchadd("NormalWhitespace", '\s\+')
highlight LeadingWhitespace ctermfg=255
call matchadd("LeadingWhitespace", '^\s\+')
highlight BadWhitespace ctermfg=255 ctermbg=9
" tabs used after start of lines
call matchadd("BadWhitespace", '\S\zs\t\+')
" whitespace at the end of lines
call matchadd("BadWhitespace", '\s\+$')
	"}}}

" soft wrapping
set breakindent
set breakindentopt=shift:2
set linebreak
"}}}

"{{{ autocommands
augroup MySh
	autocmd!
	" cursor fixes
	autocmd InsertLeave * call cursor([getpos(".")[1], getpos(".")[2]+1])
	" per filetype
	autocmd BufNewFile,BufRead *.pde let &makeprg='processing-java --sketch='.expand("%:p:h").' --run >/dev/null &'
augroup END
"}}}

