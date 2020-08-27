"{{{ functions
	"{{{ Word
" does w or b but stops at end/beginning of line
function Word(forward, big, visual)
	let l:position=line(".")
	if a:visual
		normal! gv
	endif
	if a:forward
		call eval(printf("<SNR>%d_WordMotion(v:count1, " . ((a:visual) ? "'x'" : "'n'") . ", '', [])", GetScriptNumber("wordmotion.vim")))
		"call feedkeys((a:big) ? "W" : "w", "nx")
		if line(".") != l:position
			call feedkeys("kg$", "n")
		endif
	else
		call feedkeys((a:big) ? "B" : "b", "nx")
		if line(".") != l:position
			call feedkeys("j^", "n")
		endif
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ Home
" makes home go left of whitespace only if already at 'beginning' of line
function Home(visual)
	let l:position=virtcol(".")
	if a:visual
		normal! gv
	endif
	call feedkeys("g^", "nx")
	if virtcol(".") == l:position
		call feedkeys("0", "n")
	endif
	call feedkeys("", "x")
endfunction
	"}}}

	"{{{ End
" makes end go right of comment only if already at/past its start
function End(visual)
	let l:last=@/
	if a:visual
		normal! gv
	endif
	let l:position=virtcol(".")
	let l:line=line(".")
	if match(&commentstring, '%s') != -1
		try
			call feedkeys("g^/\\s*\\V" . substitute(substitute(&commentstring, '%s', '\\m.*\\V', ""), '/', '\\/', "g") . "\\m$\<CR>", "nx")
		catch /^Vim(call):E385:.*/
			echo v:exception
		endtry
		call histdel("/", -1)
	endif
	if line(".") != l:line
		call feedkeys("\<c-o>g$", "n")
	else
		if virtcol(".") <= l:position
			call feedkeys("g$", "nx")
		endif
		if virtcol(".") == l:position && match(&commentstring, '%s') != -1
			try
				call feedkeys("g^/\\s*\\V" . substitute(substitute(&commentstring, '%s', '\\m.*\\V', ""), '/', '\\/', "g") . "\\m$\<CR>", "nx")
			catch /^Vim(call):E385:.*/
				call feedkeys("g$", "n")
			endtry
			call histdel("/", -1)
		endif
	endif
	echo
	let @/=l:last
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

	"{{{ GetSynGroup
function GetSynGroup()
	let l:s=synID(line("."), col("."), 1)
	echo synIDattr(l:s, "name") . ' -> ' . synIDattr(synIDtrans(l:s), "name")
endfunction
	"}}}

	"{{{ GetScriptNumber
function GetScriptNumber(script_name)
	redir => scriptnames
	silent! scriptnames
	redir END

	for script in split(l:scriptnames, "\n")
		if l:script =~ a:script_name
			return str2nr(split(l:script, ":")[0])
		endif
	endfor

	return -1
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

		"{{{ vim-easy-align
nmap a <Plug>(EasyAlign)
xmap a <Plug>(EasyAlign)
		"}}}

autocmd ColorScheme * hi SignatureMarkText cterm=bold ctermfg=255 ctermbg=0

nnoremap <silent> U :<c-u>UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1

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
" allow going to end of line in normal mode
set virtualedit+=onemore

" replace global by default
set gdefault
" don't timeout multi-stroke mappings
set notimeout
" enable fold markers
set foldmethod=marker
" makes things that use h and l to keep active line work better
set scrolloff=0
" scroll through history
set mouse=n
nnoremap <ScrollWheelDown> u
nnoremap <ScrollWheelUp> <c-r>

set undofile
call system("mkdir -p ~/.vim/undo")
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
" ctrl+backspace
inoremap  <Esc>dbi
nnoremap <silent> <kHome> :<c-u>call Home(0)<CR>
inoremap <silent> <kHome> <Esc>:<c-u>call Home(0) <bar> startinsert<CR>
xnoremap <silent> <kHome> :<c-u>call Home(1)<CR>
nnoremap <silent> <kEnd> :<c-u>call End(0)<CR>
inoremap <silent> <kEnd> <Esc>:<c-u>call End(0) <bar> startinsert<CR>
xnoremap <silent> <kEnd> :<c-u>call End(1)<CR>
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
" may be iffy if there's weird characters
vnoremap Y ""y:silent execute "!printf '" . substitute(substitute(substitute(substitute(getreg('"'), "'", "'\\\\''", "g"), '\', '\\\', "g"), '%', '\\%\\%', "g"), '\n', '\\n', "g") . "' <bar> xsel -ib" <bar> redraw!<CR>
" better chance of working but leaves newlines as \n
"vnoremap Y ""y:silent execute "!printf '\\%s' '" . substitute(substitute(substitute(getreg('"'), "'", "'\\\\''", "g"), '\n', '\\n', "g"), '%', '\\%', "g") . "' <bar> xsel -ib" <bar> redraw!<CR>
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
" up/down 1/2 page
nnoremap <silent> tu :<c-u>mark `<CR><c-u>``
nnoremap <silent> td :<c-u>mark `<CR><c-d>``
nnoremap tv gv

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
nmap tc t<Up>
nmap tmmc tc
		"}}}

		"{{{ scrolling to screen percentage
nnoremap tt H
xnoremap tt H
nnoremap <silent> t1 :<c-u>call ScrollScreenPercent(10, 0)<CR>
xnoremap <silent> t1 :<c-u>call ScrollScreenPercent(10, 1)<CR>
nnoremap <silent> t2 :<c-u>call ScrollScreenPercent(20, 0)<CR>
xnoremap <silent> t2 :<c-u>call ScrollScreenPercent(20, 1)<CR>
nnoremap <silent> t3 :<c-u>call ScrollScreenPercent(30, 0)<CR>
xnoremap <silent> t3 :<c-u>call ScrollScreenPercent(30, 1)<CR>
nnoremap <silent> t4 :<c-u>call ScrollScreenPercent(40, 0)<CR>
xnoremap <silent> t4 :<c-u>call ScrollScreenPercent(40, 1)<CR>
nnoremap <silent> t5 :<c-u>call ScrollScreenPercent(50, 0)<CR>
xnoremap <silent> t5 :<c-u>call ScrollScreenPercent(50, 1)<CR>
nnoremap <silent> t6 :<c-u>call ScrollScreenPercent(60, 0)<CR>
xnoremap <silent> t6 :<c-u>call ScrollScreenPercent(60, 1)<CR>
nnoremap <silent> t7 :<c-u>call ScrollScreenPercent(70, 0)<CR>
xnoremap <silent> t7 :<c-u>call ScrollScreenPercent(70, 1)<CR>
nnoremap <silent> t8 :<c-u>call ScrollScreenPercent(80, 0)<CR>
xnoremap <silent> t8 :<c-u>call ScrollScreenPercent(80, 1)<CR>
nnoremap <silent> t9 :<c-u>call ScrollScreenPercent(90, 0)<CR>
xnoremap <silent> t9 :<c-u>call ScrollScreenPercent(90, 1)<CR>
nnoremap t0 L
xnoremap t0 L
		"}}}
	"}}}

	"{{{ enclosing characters

		"{{{ parentheses
inoremap () ()<Left>
inoremap (); ();
inoremap (). ().
inoremap (), (),
inoremap (): ():
inoremap ()<Space> ()<Space>
inoremap ()<CR> ()<CR>
xnoremap ( di(<c-r>")<Esc>
imap )( ()
xmap ) (
		"}}}

		"{{{ brackets
inoremap [] []<Left>
inoremap []<Space> [<Space><Space>]<Left><Left>
inoremap []<CR> []<CR>
imap [) []
xnoremap [ di[<Space><c-r>"<Space>]<Esc>
xmap ] [
		"}}}

		"{{{ carats
inoremap <> <><Left>
inoremap <><Space> <><Space>
inoremap <><CR> <><CR>
		"}}}

		"{{{ double quotes
inoremap "" ""<Left>
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
inoremap ''. ''.
inoremap '', '',
inoremap ''<Space> ''<Space>
inoremap ''<CR> ''<CR>
xnoremap ' di'<c-r>"'<Esc>
		"}}}

		"{{{ backticks
inoremap `` ``<Left>
inoremap ``<Space> ``<Space>
inoremap ``<CR> ``<CR>
xnoremap ` di`<c-r>"`<Esc>
		"}}}

		"{{{ curly brackets
inoremap {} {}<Left>
inoremap {}<Space> {<Space><Space>}<Left><Left>
imap {) {}
" the t is to keep indent level
inoremap {<CR> {<CR>t<CR>}<Up><kEnd><BS>
xnoremap { di{<Space><c-r>"<Space>}<Esc>
xmap } {
		"}}}
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
	let l:label="{{" . "{ " . substitute(substitute(getline(v:foldstart), '.*{{' . '{\s*', "", ""), '\*/$', "", "") . " }" . "}}"
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
	" per filetype
	autocmd BufNewFile,BufRead *.pde let &makeprg="processing-java --sketch=" . expand("%:p:h") . " --run >/dev/null &"
augroup END
"}}}

