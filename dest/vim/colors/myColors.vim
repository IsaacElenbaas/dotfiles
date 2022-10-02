set background=dark
highlight clear
if exists("syntax on")
	syntax reset
endif
let g:colors_name = "myColors"

hi Normal            term=NONE cterm=NONE           ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi SpecialKey        term=NONE cterm=bold           ctermfg=4    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi NonText           term=NONE cterm=bold           ctermfg=4    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Directory         term=NONE cterm=bold           ctermfg=11   ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi ErrorMsg          term=NONE cterm=bold           ctermfg=255  ctermbg=1    gui=NONE guifg=NONE guibg=NONE
"hi IncSearch         term=NONE cterm=reverse        ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi Search            term=NONE cterm=reverse        ctermfg=NONE ctermbg=3    gui=NONE guifg=NONE guibg=NONE
"hi MoreMsg           term=NONE cterm=bold           ctermfg=2    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi ModeMsg           term=NONE cterm=bold           ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi LineNr            term=NONE cterm=NONE           ctermfg=7    ctermbg=0    gui=NONE guifg=NONE guibg=NONE
hi CursorLineNr NONE
hi link CursorLineNr LineNr
"hi Question          term=NONE cterm=standout       ctermfg=2    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi StatusLine        term=NONE cterm=bold,reverse   ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi StatusLineNC      term=NONE cterm=reverse        ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi VertSplit         term=NONE cterm=bold           ctermfg=12   ctermbg=8    gui=NONE guifg=NONE guibg=NONE
"hi Title             term=NONE cterm=bold           ctermfg=5    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi Visual            term=NONE cterm=reverse        ctermfg=NONE ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi VisualNOS         term=NONE cterm=bold,underline ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi WarningMsg        term=NONE cterm=standout       ctermfg=1    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi WildMenu          term=NONE cterm=standout       ctermfg=0    ctermbg=3    gui=NONE guifg=NONE guibg=NONE
" 7 fg is clean too
hi Folded            term=NONE cterm=bold           ctermfg=9    ctermbg=8    gui=NONE guifg=NONE guibg=NONE
"hi FoldColumn        term=NONE cterm=standout       ctermfg=4    ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi DiffAdd           term=NONE cterm=bold           ctermfg=NONE ctermbg=4    gui=NONE guifg=NONE guibg=NONE
"hi DiffChange        term=NONE cterm=bold           ctermfg=NONE ctermbg=5    gui=NONE guifg=NONE guibg=NONE
"hi DiffDelete        term=NONE cterm=bold           ctermfg=4    ctermbg=6    gui=NONE guifg=NONE guibg=NONE
"hi DiffText          term=NONE cterm=bold           ctermfg=NONE ctermbg=1    gui=NONE guifg=NONE guibg=NONE
hi SignColumn        term=NONE cterm=reverse        ctermfg=0    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi Conceal           term=NONE cterm=NONE           ctermfg=7    ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi SpellBad          term=NONE cterm=reverse        ctermfg=NONE ctermbg=9    gui=NONE guifg=NONE guibg=NONE
"hi SpellCap          term=NONE cterm=reverse        ctermfg=NONE ctermbg=12   gui=NONE guifg=NONE guibg=NONE
"hi SpellRare         term=NONE cterm=reverse        ctermfg=NONE ctermbg=5    gui=NONE guifg=NONE guibg=NONE
"hi SpellLocal        term=NONE cterm=underline      ctermfg=NONE ctermbg=6    gui=NONE guifg=NONE guibg=NONE
"hi Pmenu             term=NONE cterm=NONE           ctermfg=0    ctermbg=5    gui=NONE guifg=NONE guibg=NONE
"hi PmenuSel          term=NONE cterm=NONE           ctermfg=0    ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi PmenuSbar         term=NONE cterm=NONE           ctermfg=NONE ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi PmenuThumb        term=NONE cterm=NONE           ctermfg=NONE ctermbg=0    gui=NONE guifg=NONE guibg=NONE
"hi TabLine           term=NONE cterm=underline      ctermfg=0    ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi TabLineSel        term=NONE cterm=bold           ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi TabLineFill       term=NONE cterm=reverse        ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi CursorColumn      term=NONE cterm=reverse        ctermfg=NONE ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi CursorLine        term=NONE cterm=underline      ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
"hi ColorColumn       term=NONE cterm=reverse        ctermfg=NONE ctermbg=9    gui=NONE guifg=NONE guibg=NONE
"hi StatusLineTerm    term=NONE cterm=bold,reverse   ctermfg=15   ctermbg=2    gui=NONE guifg=NONE guibg=NONE
"hi StatusLineTermNC  term=NONE cterm=reverse        ctermfg=15   ctermbg=2    gui=NONE guifg=NONE guibg=NONE
"hi MatchParen        term=NONE cterm=reverse        ctermfg=NONE ctermbg=6    gui=NONE guifg=NONE guibg=NONE
"hi ToolbarLine       term=NONE cterm=underline      ctermfg=NONE ctermbg=7    gui=NONE guifg=NONE guibg=NONE
"hi ToolbarButton     term=NONE cterm=bold           ctermfg=NONE ctermbg=7    gui=NONE guifg=NONE guibg=NONE

" colors for syntax highlighting
hi Comment           term=NONE cterm=NONE           ctermfg=4    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Constant          term=NONE cterm=NONE           ctermfg=5    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
" matching Constant with bold
hi Special           term=NONE cterm=bold           ctermfg=5    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Identifier        term=NONE cterm=NONE           ctermfg=6    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Statement         term=NONE cterm=bold           ctermfg=2    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
" matching Constant with underline
hi PreProc           term=NONE cterm=underline      ctermfg=5    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Type NONE
hi link Type Identifier
hi Underlined        term=NONE cterm=underline      ctermfg=5    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Ignore            term=NONE cterm=NONE           ctermfg=0    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Error NONE
hi link Error ErrorMsg
" matching Comment with reverse
hi Todo              term=NONE cterm=reverse        ctermfg=4    ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
