"{{{ functions
	"{{{ Word
" does w or b but stops at end/beginning of line
function Word(forward, big, visual)
	let l:position=winline()
	if a:visual
		normal! gv
	endif
	if a:forward
		if !a:big
			call wordmotion#motion(v:count1, (a:visual) ? "x" : "n", "", 0, [])
		else
			call feedkeys("W", "nx")
		endif
		"call feedkeys((a:big) ? "W" : "w", "nx")
		if winline() != l:position
			call feedkeys("gkg$", "n")
		endif
	else
		if !a:big
			call wordmotion#motion(v:count1, (a:visual) ? "x" : "n", "b", 0, [])
		else
			call feedkeys("B", "nx")
		endif
		"call feedkeys((a:big) ? "B" : "b", "nx")
		if winline() != l:position
			call feedkeys("gjg^", "n")
		endif
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ Home
" makes home go left of whitespace only if already at 'beginning' of line
function Home(visual)
	let l:position=col(".")
	if a:visual
		normal! gv
	endif
	call feedkeys("g^", "nx")
	if col(".") == l:position
		call feedkeys("0g^", "nx")
	endif
	if col(".") == l:position
		call feedkeys("0", "n")
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ End
" makes end go right of comment only if already at/past its start
function End(visual)
	if a:visual
		normal! gv
	endif
	let l:oldcol=col(".")
	let l:oldnum=line(".")
	call feedkeys("^", "nx")
	if match(&commentstring, '%s') != -1
		" no c flag to prevent going to beginning on only comment lines
		let [cnum, ccol]=searchpos('\s*\V' . substitute(&commentstring, '%s', '\\m.*\\V', "") . '\m$', "n")
	endif
	call cursor(0, l:oldcol)
	" no comment on line
	if l:cnum != l:oldnum
		call feedkeys("g$", "nx")
		if col(".") == l:oldcol
			call feedkeys("$g$", "n")
		endif
	" comment on line
	else
		call feedkeys("g$", "nx")
		" at/past comment start
		if l:ccol <= l:oldcol
			" soft wrapped line
			if col(".") == l:oldcol
				call feedkeys("$g$", "nx")
			endif
			if col(".") == l:oldcol
				call cursor(0, l:ccol)
			endif
		" before comment start
		elseif col(".") == l:oldcol || col(".") > l:ccol
			" comment starts before end of soft wrapped line or already at end of soft wrapped
			call cursor(0, l:ccol)
		endif
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ In/Outdent
" makes 2>2j indent three lines two times
function Indent(...)
	if exists("a:1")
		call feedkeys("`[V`]" . g:temp . ">", "n")
	else
		call feedkeys("V" . g:temp . ">", "n")
	endif
	call feedkeys("", "x")
endfunction
function Outdent(...)
	if exists("a:1")
		call feedkeys("`[V`]" . g:temp . "<", "n")
	else
		call feedkeys("V" . g:temp . "<", "n")
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ ScrollOnlyScreenPercent
function ScrollOnlyScreenPercent(percent, visual)
	let l:position=line(".")
	call feedkeys("H", "nx")
	let l:i=0
	while line(".") < l:position
		call feedkeys("j", "nx")
		let i+=1
	endwhile
	let l:diff=a:percent*winheight("%")/100-l:i
	if l:diff > 0
		call feedkeys(l:diff . "\<c-y>", "n")
	elseif l:diff < 0
		call feedkeys(-1*l:diff . "\<c-e>", "n")
	endif
	if a:visual
		normal! gv
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ ScrollScreenPercent
function ScrollScreenPercent(percent, visual)
	call feedkeys("H" . a:percent*winheight("%")/100 . "j", "n")
	if a:visual
		let l:scroll=line(".")
		call feedkeys("gv" . l:scroll . "gg", "n")
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ ScrollPercent
" scrolls to visible percentage even when there are folds
function ScrollPercent(percent, visual)
	call feedkeys("G", "nx")
	let l:i=0
	while line(".") > 1
		call feedkeys((1+line("$")/1000) . "k", "nx")
		let i+=1+line('$')/1000
	endwhile
	call feedkeys(a:percent*l:i/100 . "j", "nx")
	if a:visual
		let l:scroll=line(".")
		call feedkeys("gv" . l:scroll . "ggzz", "n")
	else
		call feedkeys("zz", "n")
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ ToggleFold
	" same as za but keeps cursor position on screen
function ToggleFold()
	let l:position=line(".")
	let l:closed=foldclosed(line("."))
	call feedkeys("H", "nx")
	let l:i=0
	while line(".") < ((l:closed == -1) ? l:position : l:closed)
		call feedkeys("j", "nx")
		let i+=1
	endwhile
	silent! normal! za
	call feedkeys(l:position . "gg" . l:i . "kzt" . l:position . "gg", "n")
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ ToggleAllFolds
function ToggleAllFolds()
	let l:position=line(".")
	call feedkeys("G", "n")
	call feedkeys((line("$")-2) . "k", "nx")
	call feedkeys(((line(".") == 1) ? "zR" : "zM"), "n")
	call feedkeys(l:position . "gg", "n")
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ SelectFold
function SelectFold(around)
	let l:position=line(".")
	if foldclosed(l:position) == -1
		call feedkeys("za", "nx")
		let l:start=foldclosed(l:position)
		if l:start == -1
			return
		endif
		let l:end=foldclosedend(l:position)
		call feedkeys("za" . (l:start+((a:around) ? 0 : 1)) . "GV" . (l:end-((a:around) ? 0 : 1)) . "G", "n")
	else
		call feedkeys("V", "n")
	endif
	call feedkeys("", "x")
endfunction
	"}}}
"}}}

"{{{ plugins
	"{{{ plugin installation
" :PlugInstall :PlugClean :PlugUpdate :PlugUpdate
call plug#begin('~/.vim/plugged')
Plug 'chaoren/vim-wordmotion'
Plug 'dstein64/vim-startuptime'
Plug 'dylanaraps/fff.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kshenoy/vim-signature'
Plug 'mbbill/undotree'
Plug 'sirtaj/vim-openscad'
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'terryma/vim-expand-region'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'SirVer/ultisnips'
call plug#end()
	"}}}

	"{{{ plugin config
		"{{{ vim-wordmotion
runtime plugin/wordmotion.vim
nnoremap <silent> w :<c-u>call Word(1, 0, 0)<CR>
xnoremap <silent> w :<c-u>call Word(1, 0, 1)<CR>
nnoremap <silent> b :<c-u>call Word(0, 0, 0)<CR>
xnoremap <silent> b :<c-u>call Word(0, 0, 1)<CR>
nnoremap <silent> W :<c-u>call Word(1, 1, 0)<CR>
xnoremap <silent> W :<c-u>call Word(1, 1, 1)<CR>
nnoremap <silent> B :<c-u>call Word(0, 1, 0)<CR>
xnoremap <silent> B :<c-u>call Word(0, 1, 1)<CR>
xnoremap is iw
onoremap is iw
xnoremap as aw
onoremap as aw
		"}}}

let g:fff#split="20new"

let g:lightline = {
	\ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '', 'right': '' }
	\ }

		"{{{ vim-easy-align
nmap a <Plug>(EasyAlign)
xmap a <Plug>(EasyAlign)
		"}}}

autocmd ColorScheme * hi SignatureMarkText cterm=bold ctermfg=255 ctermbg=0

		"{{{ vim-undotree
nnoremap <silent> U :<c-u>UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
		"}}}

		"{{{ vim-expand-region
call expand_region#custom_text_objects({"is" :0,"if" :0})
nmap h <Plug>(expand_region_expand)
xmap h <Plug>(expand_region_expand)
xmap t <Plug>(expand_region_shrink)
		"}}}

		"{{{ quick-scope
let g:qs_second_highlight=0
augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary term=NONE cterm=NONE ctermfg=NONE ctermbg=240 gui=NONE guifg=NONE guifg=NONE guibg=NONE
augroup END
		"}}}

" just here so I don't get confused when stuff in settings don't apply
runtime! plugin/sensible.vim

		"{{{ ultisnips
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
"}}}

"{{{ settings
" screw the python styleguide
let g:python_recommended_style=0
" use 256 color
set t_Co=256
" hybrid number rows
set number
set relativenumber
" don't show mode on command line
set noshowmode
" show pending keys
set showcmd
" allow going to end of line in normal mode
set virtualedit+=onemore

" replace global by default
set gdefault
" don't timeout multi-stroke mappings
set notimeout
" control sequence delay
set ttimeoutlen=10
" enable fold markers
set foldmethod=marker
" makes things that use h and l to keep active line work better
set scrolloff=0
" speed
set lazyredraw
set ttyfast
" scroll through history
" mouse support breaks everything in the weirdest of ways never touch it again
"set mouse=n
"nnoremap <ScrollWheelDown> u
"nnoremap <ScrollWheelUp> <c-r>

set undofile
silent call mkdir($HOME . "/.vim/undo", "p")
set undodir=$HOME/.vim/undo

	"{{{ searching
" highlight all matches when searching
set hlsearch
set ignorecase
set smartcase
set nowrapscan
	"}}}

	"{{{ indentation
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
command D execute "w !git diff --no-index --color=always -- % - | less -R" | execute "silent! !stty sane" | redraw!
command M silent make<bar>call feedkeys("\<lt>CR>", "n")
	"}}}

	"{{{ broken keys/key combos
nnoremap <silent> <Home> :<c-u>call Home(0)<CR>
inoremap <silent> <Home> <Esc>:<c-u>call Home(0) <bar> startinsert<CR>
xnoremap <silent> <Home> :<c-u>call Home(1)<CR>
map <kHome> <Home>
nnoremap <silent> <End> :<c-u>call End(0)<CR>
inoremap <silent> <End> <Esc>:<c-u>call End(0) <bar> startinsert<CR>
xnoremap <silent> <End> :<c-u>call End(1)<CR>
map <kEnd> <End>
	"}}}

	"{{{ misc.
nnoremap Q :
nnoremap q :<c-u>q<CR>
nnoremap dD g^D
nnoremap cC g^C
nnoremap x "_d
xnoremap x "_d
nnoremap xx "_dd
nnoremap X "_D
nmap xX g^X
nnoremap Y y$
nmap yY g^Y
" may be iffy if there's weird characters, add any basic vim special ones to innermost substitute group
vnoremap Y ""y:silent execute "!printf -- '" . substitute(substitute(substitute(substitute(substitute(getreg('"'), '\(\\\\|#\)\@=', '\\', "g"), '%', '\\%\\%', "g"), '!', '\\!', "g"), '\n', '\\n', "g"), "'", "'\\\\''", "g") . "' <bar> xsel -ib" <bar> redraw!<CR>
" better chance of working but leaves newlines as \n
"vnoremap Y ""y:silent execute "!printf -- '\\%s' '" . substitute(substitute(substitute(getreg('"'), "'", "'\\\\''", "g"), '\n', '\\n', "g"), '%', '\\%', "g") . "' <bar> xsel -ib" <bar> redraw!<CR>
nnoremap <silent> <Leader>/ :<c-u>noh<CR>
nnoremap j gJ
inoremap <bar>& <bar><bar>

	"{{{ basic movement
map <c-Right> w
map <c-Left> b
nnoremap <silent> <Tab> :<c-u>let temp=@/<CR>:call cursor([getpos(".")[1], getpos(".")[2]-1])<CR>/(.\{-})\<bar><.\{-}>\<bar>\[.\{-}]\<bar>{.\{-}}\<bar>".\{-}"\<bar>'.\{-}'<CR><Right>:let @/=g:temp<CR>
nnoremap <silent> <S-Tab> :<c-u>let temp=@/<CR>:call cursor([getpos(".")[1], getpos(".")[2]-1])<CR>?(.\{-})\<bar><.\{-}>\<bar>\[.\{-}]\<bar>{.\{-}}\<bar>".\{-}"\<bar>'.\{-}'<CR><Right>:let @/=g:temp<CR>
nnoremap $ g$
map M zz
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

	"{{{ pasting
nnoremap p P`.
nnoremap P gP
" janky in visual-block but works
xnoremap <expr> p (mode() == "\<c-v>") ? ('I<c-r>"' . repeat("\<Left>", strchars(getreg('"')))) : "P`."
xnoremap <expr> P (mode() == "\<c-v>") ? 'I<c-r>"' : "gP"
	"}}}

	"{{{ indenting
nnoremap <silent> > :<c-u>execute "let temp=" . v:count1<CR>:set opfunc=Indent<CR>g@
nnoremap <silent> >> :<c-u>execute "let temp=" . v:count1<CR>:call Indent()<CR>
nnoremap <silent> < :<c-u>execute "let temp=" . v:count1<CR>:set opfunc=Outdent<CR>g@
nnoremap <silent> << :<c-u>execute "let temp=" . v:count1<CR>:call Outdent()<CR>
	"}}}

		"{{{ folds
nnoremap <silent> <Space> :<c-u>call ToggleFold()<CR>
nnoremap <silent> z<Space> :<c-u>call ToggleAllFolds()<CR>
xnoremap <silent> if :<c-u>call SelectFold(0)<CR>
onoremap <silent> if :<c-u>call SelectFold(0)<CR>
xnoremap <silent> af :<c-u>call SelectFold(1)<CR>
onoremap <silent> af :<c-u>call SelectFold(1)<CR>
		"}}}
	"}}}

	"{{{ travelling
nnoremap tm '
xnoremap tm '
" back/forward in jump history
nnoremap tb <c-o>
nnoremap tf <c-i>
nnoremap tv gv
xnoremap tv gv

		"{{{ scrolling
nnoremap tmm <Nop>
nmap <silent> tn :<c-u>call signature#mark#Goto("next", "spot", "pos")<CR>tmm
nmap tmmn tn
nmap <silent> tN :<c-u>call signature#mark#Goto("prev", "spot", "pos")<CR>tmm
nmap tmmN tN
nmap <silent> t<Down> :<c-u>execute "normal! 2\<lt>c-e>M"<CR>tmm
nmap tmm<Down> t<Down>
nmap tmmt t<Down>
nmap <silent> t<Up> :<c-u>execute "normal! 2\<lt>c-y>M"<CR>tmm
nmap tmm<Up> t<Up>
nmap tmmc t<Up>
		"}}}

		"{{{ scrolling to screen percentage
nnoremap tt H
nnoremap <silent> t1 :<c-u>call ScrollScreenPercent(10, 0)<CR>
nnoremap <silent> t2 :<c-u>call ScrollScreenPercent(20, 0)<CR>
nnoremap <silent> t3 :<c-u>call ScrollScreenPercent(30, 0)<CR>
nnoremap <silent> t4 :<c-u>call ScrollScreenPercent(40, 0)<CR>
nnoremap <silent> t5 :<c-u>call ScrollScreenPercent(50, 0)<CR>
nnoremap <silent> t6 :<c-u>call ScrollScreenPercent(60, 0)<CR>
nnoremap <silent> t7 :<c-u>call ScrollScreenPercent(70, 0)<CR>
nnoremap <silent> t8 :<c-u>call ScrollScreenPercent(80, 0)<CR>
nnoremap <silent> t9 :<c-u>call ScrollScreenPercent(90, 0)<CR>
nnoremap t0 L
		"}}}
	"}}}

	"{{{ enclosing characters
" {) -> {)<Left> and similar are still necessary with snippets because mappings break them

		"{{{ parentheses
inoremap () ()<Left>
inoremap ()<Left> ()<Left>
inoremap (). ().
inoremap (), (),
inoremap ()<Space> ()<Space>
inoremap ()<CR> ()<CR>
xnoremap ( di(<c-r>")<Esc>
xmap ) (
		"}}}

		"{{{ brackets
inoremap [] []<Left>
inoremap []<Left> []<Left>
inoremap [], [],
inoremap []<Space> []<Space>
inoremap []<CR> []<CR>
imap [) []
xnoremap [ di[<Space><c-r>"<Space>]<Esc>
xmap ] [
		"}}}

		"{{{ carats
inoremap <> <><Left>
inoremap <><Left> <><Left>
inoremap <><Space> <><Space>
inoremap <><CR> <><CR>
		"}}}

		"{{{ double quotes
inoremap "" ""<Left>
inoremap ""<Left> ""<Left>
inoremap "". "".
inoremap "", "",
inoremap ""<Space> ""<Space>
inoremap ""<CR> ""<CR>
imap "' ""
imap '" ""
xnoremap " di"<c-r>""<Esc>
		"}}}

		"{{{ single quotes
inoremap '' ''<Left>
inoremap ''<Left> ''<Left>
inoremap ''. ''.
inoremap '', '',
inoremap ''<Space> ''<Space>
inoremap ''<CR> ''<CR>
xnoremap ' di'<c-r>"'<Esc>
		"}}}

		"{{{ backticks
inoremap `` ``<Left>
inoremap ``<Left> ``<Left>
inoremap ``<Space> ``<Space>
inoremap ``<CR> ``<CR>
xnoremap ` di`<c-r>"`<Esc>
		"}}}

		"{{{ curly brackets
inoremap {} {}<Left>
inoremap {}<Left> {}<Left>
imap {) {}
" the t is to keep indent level
inoremap {<CR> {<CR>t<CR>}<Up><kEnd><BS>
xnoremap { di{<Space><c-r>"<Space>}<Esc>
xmap } {
		"}}}
	"}}}

	"{{{ screen scrolling
nnoremap cmm <Nop>
nmap <silent> c<Down> :<c-u>execute "normal! 2\<lt>c-e>"<CR>cmm
nmap cmm<Down> c<Down>
nmap cmmt c<Down>
nmap <silent> c<Up> :<c-u>execute "normal! 2\<lt>c-y>"<CR>cmm
nmap cmm<Up> c<Up>
nmap cmmc c<Up>
	"}}}

	"{{{ centering to screen percentage
nnoremap cc zt
xnoremap cc zt
nnoremap <silent> c1 :<c-u>call ScrollOnlyScreenPercent(10, 0)<CR>
xnoremap <silent> c1 :<c-u>call ScrollOnlyScreenPercent(10, 1)<CR>
nnoremap <silent> c2 :<c-u>call ScrollOnlyScreenPercent(20, 0)<CR>
xnoremap <silent> c2 :<c-u>call ScrollOnlyScreenPercent(20, 1)<CR>
nnoremap <silent> c3 :<c-u>call ScrollOnlyScreenPercent(30, 0)<CR>
xnoremap <silent> c3 :<c-u>call ScrollOnlyScreenPercent(30, 1)<CR>
nnoremap <silent> c4 :<c-u>call ScrollOnlyScreenPercent(40, 0)<CR>
xnoremap <silent> c4 :<c-u>call ScrollOnlyScreenPercent(40, 1)<CR>
nnoremap <silent> c5 :<c-u>call ScrollOnlyScreenPercent(50, 0)<CR>
xnoremap <silent> c5 :<c-u>call ScrollOnlyScreenPercent(50, 1)<CR>
nnoremap <silent> c6 :<c-u>call ScrollOnlyScreenPercent(60, 0)<CR>
xnoremap <silent> c6 :<c-u>call ScrollOnlyScreenPercent(60, 1)<CR>
nnoremap <silent> c7 :<c-u>call ScrollOnlyScreenPercent(70, 0)<CR>
xnoremap <silent> c7 :<c-u>call ScrollOnlyScreenPercent(70, 1)<CR>
nnoremap <silent> c8 :<c-u>call ScrollOnlyScreenPercent(80, 0)<CR>
xnoremap <silent> c8 :<c-u>call ScrollOnlyScreenPercent(80, 1)<CR>
nnoremap <silent> c9 :<c-u>call ScrollOnlyScreenPercent(90, 0)<CR>
xnoremap <silent> c9 :<c-u>call ScrollOnlyScreenPercent(90, 1)<CR>
nnoremap c0 zb
xnoremap c0 zb
	"}}}

	"{{{ scrolling to document percentage (visible lines)
nnoremap s<Esc> <Nop>
nnoremap ss gg
xnoremap ss gg
nnoremap <silent> s1 :<c-u>call ScrollPercent(10, 0)<CR>
xnoremap <silent> s1 :<c-u>call ScrollPercent(10, 1)<CR>
nnoremap <silent> s2 :<c-u>call ScrollPercent(20, 0)<CR>
xnoremap <silent> s2 :<c-u>call ScrollPercent(20, 1)<CR>
nnoremap <silent> s3 :<c-u>call ScrollPercent(30, 0)<CR>
xnoremap <silent> s3 :<c-u>call ScrollPercent(30, 1)<CR>
nnoremap <silent> s4 :<c-u>call ScrollPercent(40, 0)<CR>
xnoremap <silent> s4 :<c-u>call ScrollPercent(40, 1)<CR>
nnoremap <silent> s5 :<c-u>call ScrollPercent(50, 0)<CR>
xnoremap <silent> s5 :<c-u>call ScrollPercent(50, 1)<CR>
nnoremap <silent> s6 :<c-u>call ScrollPercent(60, 0)<CR>
xnoremap <silent> s6 :<c-u>call ScrollPercent(60, 1)<CR>
nnoremap <silent> s7 :<c-u>call ScrollPercent(70, 0)<CR>
xnoremap <silent> s7 :<c-u>call ScrollPercent(70, 1)<CR>
nnoremap <silent> s8 :<c-u>call ScrollPercent(80, 0)<CR>
xnoremap <silent> s8 :<c-u>call ScrollPercent(80, 1)<CR>
nnoremap <silent> s9 :<c-u>call ScrollPercent(90, 0)<CR>
xnoremap <silent> s9 :<c-u>call ScrollPercent(90, 1)<CR>
nnoremap s0 G
xnoremap s0 G
	"}}}
"}}}

"{{{ theming
colorscheme myColors

	"{{{ folding
		"{{{ fold text
function! FoldText()
	if(match(&commentstring, '%s') != -1)
		let l:label="{{" . "{ " . substitute(substitute(getline(v:foldstart), '.*{{' . '{\s*', "", ""), '\s*\V' . substitute(&commentstring, '.*%s', "", "") . '\m$', "", "") . " }" . "}}"
	else
		let l:label="{{" . "{ " . substitute(getline(v:foldstart), '.*{{' . '{\s*', "", "") . " }" . "}}"
	endif
	" +2 chars at beginning makes it more obvious when something is opened
	return repeat("-", v:foldlevel*2+2) . l:label . repeat(" ", winwidth(0))
endfunction
		"}}}

		"{{{ fold markers
hi link FoldMarker Folded
hi FoldMarkerSpace ctermfg=8 ctermbg=8
augroup FoldMarkerHighlight
	autocmd!
	autocmd BufNewfile,Bufread * set foldtext=FoldText()
	" remove commentchar spaces, here so it's before these
	autocmd BufNewfile,Bufread * let &commentstring=substitute(&commentstring, '\s\+', "", "g")

	" color fold markers - only in comments
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1) | call matchadd("FoldMarker", '\V' . (substitute(&commentstring, '%s', '\\m.\\{-}\\%({{{\\|}}}\\).\\{-}\\V', "")) . ((substitute(&commentstring, '.*%s', "", "") != "") ? "" : '\m$')) | endif
	" whitespace before comment chars
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1) | call matchadd("FoldMarkerSpace", '^\s\+\%(\V' . (substitute(&commentstring, '%s', '\\m.\\{-}\\%({{{\\|}}}\\).\\{-}\\V', "")) . '\m\)\@=') | endif
	" closing part of commentstring + its preceding spaces if at end of line
	autocmd BufNewfile,Bufread * if(match(&commentstring, '%s') != -1 && substitute(&commentstring, '.*%s', "", "") != "") | call matchadd("FoldMarkerSpace", '\%(\V' . (substitute(&commentstring, '%s', '\\m.\\{-}\\%({{{\\|}}}\\).\\{-}\\)\\@<=\\s*\\V', "")) . '\m$') | endif
	" matching spaces in fold comment is near impossible because if you match
	" the fold comment with zero width and then non-matching .\{-} and \s* it
	" will match the fold comment once, get one space group, and move on
	" matching the space and lookbehind/ahead is horribly inefficient as it is
	" on every space in the file
augroup end
		"}}}
	"}}}

	"{{{ leading and bad whitespace
set list
set listchars=tab:\|\ ,space:·
" hides listchars for non-leading whitespace (as best as possible, BG doesn't seem to be referenceable and 0 is as close as you can get without hardcoding
highlight NormalWhitespace ctermfg=0
call matchadd("NormalWhitespace", ' \+')
highlight LeadingWhitespace ctermfg=255
call matchadd("LeadingWhitespace", '^\s\+')
highlight BadWhitespace ctermfg=255 ctermbg=9
" tabs used after start of lines
call matchadd("BadWhitespace", '[^^\t]\zs\t\+')
" whitespace at the end of lines
call matchadd("BadWhitespace", '\s\+$')
" if accidentally sent two spaces
call matchadd("BadWhitespace", '\S\zs\s\{2\}\ze\S')
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
	autocmd BufNewFile,BufRead * set textwidth=0
	" per filetype
	autocmd BufNewFile,BufRead *.pde let &makeprg="processing-java --sketch=" . expand("%:p:h") . " --run >/dev/null &"
augroup END
"}}}

"{{{ terminal
	"{{{ Terminal
function Terminal()
	if $VIM_TERMINAL == ""
		call lightline#disable()
		set laststatus=0
		set noshowcmd
		set noruler
	endif
	" sets up terminal mode mappings
	call Tapi_scEnd(1, [])

		"{{{ normal mode mappings
	" normal mode mappings can always be present as they don't need to be disabled for sc or paste (you'll be in insert and can't even get to normal in sc's case)
	if $VIM_TERMINAL == ""
		nnoremap r :<c-u>call Tapi_rename(0, [0])<CR>
	endif
	" <BS> is for if it's not zsh
	nnoremap <silent> dt :<c-u>call term_sendkeys(1, "\<lt>c-u>t\<lt>BS>")<CR>i
	nnoremap <silent> dd :<c-u>call term_sendkeys(1, "\<lt>c-u>d\<lt>BS>")<CR>i
	nnoremap <silent> xx :<c-u>call term_sendkeys(1, "\<lt>c-u>x\<lt>BS>")<CR>i
	nnoremap <silent> p :<c-u>call setreg("", substitute(substitute(getreg(""), '\(\n\)\?[^\n]* ', '\1', "g"), '\n$', '', "g"))<CR>i<c-w>""
		"}}}

endfunction
"}}}

	"{{{ TerminalEnd
function TerminalEnd()
	try
		nunmap r
	catch /^.*E31:.*/
	endtry
	try
		nunmap dt
		nunmap dd
		nunmap xx
		nunmap p
	catch /^.*E31:.*/
	endtry
endfunction
	"}}}

augroup Terminal
	autocmd!
	autocmd TerminalWinOpen * call Terminal()
	autocmd VimEnter * exe "set t_ts=\<Esc>]51; t_fs=\x07" | let &titlestring = '["call","Tapi_sc",[]]'    | set title | redraw | set notitle | set t_ts& t_fs&
	autocmd VimLeave * exe "set t_ts=\<Esc>]51; t_fs=\x07" | let &titlestring = '["call","Tapi_scEnd",[]]' | set title | redraw | set notitle | set t_ts& t_fs&
	autocmd BufDelete * call TerminalEnd()
augroup END

"{{{ Tapi_rename
" automatically or manually changes title in screen
function Tapi_rename(bufnum, arglist)
	if $STY
		if a:bufnum
			let name=a:arglist[0]
		else
			call inputsave()
			let name=input("Enter name: ")
			call inputrestore()
			let g:screenTitle=1
			if l:name == ""
				unlet g:screenTitle
				let name="-----"
			endif
		endif
		if !a:bufnum || (a:bufnum && !exists("g:screenTitle"))
			exe "set t_ts=\<Esc>k t_fs=\<Esc>\\"
			let &titlestring = l:name
			set title
			redraw
			set notitle
			set t_ts& t_fs&
		endif
	endif
endfunction
"}}}

	"{{{ Tapi_mappings
function Tapi_mappings()
		"{{{ misc.
tnoremap <bar>& <bar><bar>
		"}}}

		"{{{ enclosing characters
			"{{{ parentheses
tnoremap () ()<Left>
tnoremap (). ().
tnoremap (), (),
tnoremap ()<Space> ()<Space>
tnoremap ()<CR> ()<CR>
			"}}}

			"{{{ brackets
tnoremap [] []<Left>
tnoremap [], [],
tnoremap []<Space> []<Space>
tnoremap []<CR> []<CR>
tmap [) []
			"}}}

			"{{{ carats
tnoremap <> <><Left>
tnoremap <><Space> <><Space>
tnoremap <><CR> <><CR>
			"}}}

			"{{{ double quotes
tnoremap "" ""<Left>
tnoremap "". "".
tnoremap "", "",
tnoremap ""<Space> ""<Space>
tnoremap ""<CR> ""<CR>
tmap "' ""
tmap '" ""
			"}}}

			"{{{ single quotes
tnoremap '' ''<Left>
tnoremap ''. ''.
tnoremap '', '',
tnoremap ''<Space> ''<Space>
tnoremap ''<CR> ''<CR>
			"}}}

			"{{{ backticks
tnoremap `` ``<Left>
tnoremap ``<Space> ``<Space>
tnoremap ``<CR> ``<CR>
			"}}}

			"{{{ curly brackets
tnoremap {} {}<Left>
tmap {) {}
			"}}}
		"}}}
endfunc
	"}}}

	"{{{ Tapi_sc
" disable outer binds on sc or in vim
function Tapi_sc(bufnum, arglist)
	try
		"{{{ mappings
			"{{{ misc.
		tunmap <bar>&
			"}}}

			"{{{ enclosing characters
				"{{{ parentheses
		tunmap ()
		tunmap ().
		tunmap (),
		tunmap ()<Space>
		tunmap ()<CR>
				"}}}

				"{{{ brackets
		tunmap []
		tunmap [],
		tunmap []<Space>
		tunmap []<CR>
		tunmap [)
				"}}}

				"{{{ carats
		tunmap <>
		tunmap <><Space>
		tunmap <><CR>
				"}}}

				"{{{ double quotes
		tunmap ""
		tunmap "".
		tunmap "",
		tunmap ""<Space>
		tunmap ""<CR>
		tunmap "'
		tunmap '"
				"}}}

				"{{{ single quotes
		tunmap ''
		tunmap ''.
		tunmap '',
		tunmap ''<Space>
		tunmap ''<CR>
				"}}}

				"{{{ backticks
		tunmap ``
		tunmap ``<Space>
		tunmap ``<CR>
				"}}}

				"{{{ curly brackets
		tunmap {}
		tunmap {)
				"}}}
			"}}}
		"}}}
	catch /^.*E31:.*/
	endtry
	" setting termwinkey doesn't make c-w pass through
	tnoremap <expr> <c-w> (term_sendkeys(1, "\<c-w>"))?"":""
endfunc
	"}}}

	"{{{ Tapi_scEnd
" restore binds if aborted sc or exited vim
function Tapi_scEnd(bufnum, arglist)
	call Tapi_mappings()
	tnoremap <c-w> <c-w>N
endfunc
	"}}}

	"{{{ Tapi_yank
function Tapi_yank(bufnum, arglist)
	let @@=a:arglist[0]
endfunc
	"}}}

	"{{{ broken keys/key combos
" for some reason map kHome Home and similar above don't apply to this (so it is kHome not Home), and mapping to <Home> doesn't work but the escape sequence does
tnoremap <kHome> [1~
tnoremap <kEnd> [4~
	"}}}

tnoremap <c-w> <c-w>N
"}}}
