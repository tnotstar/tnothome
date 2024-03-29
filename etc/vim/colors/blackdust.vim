" Vim color file - blackdust
" Generated by http://bytefluent.com/vivify 2022-02-09
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "blackdust"

"hi SignColumn -- no settings --
"hi TabLineSel -- no settings --
"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
"hi Ignore -- no settings --
hi Normal guifg=#cccccc guibg=#3f3f3f guisp=#3f3f3f gui=NONE ctermfg=252 ctermbg=237 cterm=NONE
"hi CTagsImport -- no settings --
"hi CTagsGlobalVariable -- no settings --
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
"hi CursorLine -- no settings --
"hi Union -- no settings --
"hi TabLineFill -- no settings --
"hi CursorColumn -- no settings --
"hi EnumerationName -- no settings --
"hi SpellCap -- no settings --
"hi SpellLocal -- no settings --
"hi DefinedName -- no settings --
"hi MatchParen -- no settings --
"hi LocalVariable -- no settings --
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
"hi Underlined -- no settings --
"hi TabLine -- no settings --
"hi clear -- no settings --
"hi htmlitalic -- no settings --
"hi htmlboldunderlineitalic -- no settings --
"hi htmlbolditalic -- no settings --
"hi htmlunderlineitalic -- no settings --
"hi htmlbold -- no settings --
"hi htmlboldunderline -- no settings --
"hi htmlunderline -- no settings --
"hi default -- no settings --
"hi htmllink -- no settings --
hi IncSearch guifg=#000000 guibg=#c15c66 guisp=#c15c66 gui=NONE ctermfg=NONE ctermbg=131 cterm=NONE
hi WildMenu guifg=#000000 guibg=#dca3a3 guisp=#dca3a3 gui=NONE ctermfg=NONE ctermbg=181 cterm=NONE
hi SpecialComment guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi Typedef guifg=#ffffff guibg=NONE guisp=NONE gui=bold,underline ctermfg=15 ctermbg=NONE cterm=bold,underline
hi Title guifg=#ffffff guibg=#333333 guisp=#333333 gui=bold ctermfg=15 ctermbg=236 cterm=bold
hi Folded guifg=#dca3a3 guibg=#333333 guisp=#333333 gui=NONE ctermfg=181 ctermbg=236 cterm=NONE
hi PreCondit guifg=#dfaf8f guibg=NONE guisp=NONE gui=bold ctermfg=180 ctermbg=NONE cterm=bold
hi Include guifg=#ffcfaf guibg=NONE guisp=NONE gui=bold ctermfg=223 ctermbg=NONE cterm=bold
hi StatusLineNC guifg=#333333 guibg=#cccccc guisp=#cccccc gui=NONE ctermfg=236 ctermbg=252 cterm=NONE
hi NonText guifg=#1f1f1f guibg=NONE guisp=NONE gui=NONE ctermfg=234 ctermbg=NONE cterm=NONE
hi DiffText guifg=#ffffff guibg=#1f1f1f guisp=#1f1f1f gui=bold ctermfg=15 ctermbg=234 cterm=bold
hi ErrorMsg guifg=#000000 guibg=#00c0cf guisp=#00c0cf gui=NONE ctermfg=NONE ctermbg=44 cterm=NONE
hi Debug guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi PMenuSbar guifg=NONE guibg=#464646 guisp=#464646 gui=NONE ctermfg=NONE ctermbg=238 cterm=NONE
hi Identifier guifg=#ffffff guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi Conditional guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi StorageClass guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Todo guifg=#ffffff guibg=#000000 guisp=#000000 gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Special guifg=#7f7f7f guibg=NONE guisp=NONE gui=NONE ctermfg=8 ctermbg=NONE cterm=NONE
hi LineNr guifg=#7f7f7f guibg=#464646 guisp=#464646 gui=NONE ctermfg=8 ctermbg=238 cterm=NONE
hi StatusLine guifg=#333333 guibg=#f18c96 guisp=#f18c96 gui=NONE ctermfg=236 ctermbg=210 cterm=NONE
hi Label guifg=#8fffff guibg=NONE guisp=NONE gui=underline ctermfg=123 ctermbg=NONE cterm=underline
hi PMenuSel guifg=#333333 guibg=#f18c96 guisp=#f18c96 gui=NONE ctermfg=236 ctermbg=210 cterm=NONE
hi Search guifg=#000000 guibg=#c15c66 guisp=#c15c66 gui=NONE ctermfg=NONE ctermbg=131 cterm=NONE
hi Delimiter guifg=#8f8f8f guibg=NONE guisp=NONE gui=NONE ctermfg=245 ctermbg=NONE cterm=NONE
hi Statement guifg=#8fffff guibg=NONE guisp=NONE gui=NONE ctermfg=123 ctermbg=NONE cterm=NONE
hi Comment guifg=#7f7f7f guibg=NONE guisp=NONE gui=NONE ctermfg=8 ctermbg=NONE cterm=NONE
hi Character guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi Float guifg=#9c93b3 guibg=NONE guisp=NONE gui=NONE ctermfg=103 ctermbg=NONE cterm=NONE
hi Number guifg=#aca0a3 guibg=NONE guisp=NONE gui=NONE ctermfg=145 ctermbg=NONE cterm=NONE
hi Boolean guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi Operator guifg=#ffffff guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi Question guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi WarningMsg guifg=#ffffff guibg=#333333 guisp=#333333 gui=bold ctermfg=15 ctermbg=236 cterm=bold
hi VisualNOS guifg=#333333 guibg=#f18c96 guisp=#f18c96 gui=bold,underline ctermfg=236 ctermbg=210 cterm=bold,underline
hi DiffDelete guifg=#333333 guibg=#464646 guisp=#464646 gui=NONE ctermfg=236 ctermbg=238 cterm=NONE
hi ModeMsg guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi Define guifg=#ffcfaf guibg=NONE guisp=NONE gui=bold ctermfg=223 ctermbg=NONE cterm=bold
hi Function guifg=#ffff8f guibg=NONE guisp=NONE gui=NONE ctermfg=228 ctermbg=NONE cterm=NONE
hi FoldColumn guifg=#dca3a3 guibg=#464646 guisp=#464646 gui=NONE ctermfg=181 ctermbg=238 cterm=NONE
hi PreProc guifg=#ffcfaf guibg=NONE guisp=NONE gui=bold ctermfg=223 ctermbg=NONE cterm=bold
hi Visual guifg=#333333 guibg=#f18c96 guisp=#f18c96 gui=NONE ctermfg=236 ctermbg=210 cterm=NONE
hi MoreMsg guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi VertSplit guifg=#333333 guibg=#cccccc guisp=#cccccc gui=NONE ctermfg=236 ctermbg=252 cterm=NONE
hi Exception guifg=#8fffff guibg=NONE guisp=NONE gui=underline ctermfg=123 ctermbg=NONE cterm=underline
hi Keyword guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Type guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi DiffChange guifg=NONE guibg=#333333 guisp=#333333 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi Cursor guifg=#000000 guibg=#aeaeae guisp=#aeaeae gui=NONE ctermfg=NONE ctermbg=145 cterm=NONE
hi Error guifg=#000000 guibg=#00ffff guisp=#00ffff gui=NONE ctermfg=NONE ctermbg=14 cterm=NONE
hi PMenu guifg=#333333 guibg=#cccccc guisp=#cccccc gui=NONE ctermfg=236 ctermbg=252 cterm=NONE
hi SpecialKey guifg=#7e7e7e guibg=NONE guisp=NONE gui=NONE ctermfg=8 ctermbg=NONE cterm=NONE
hi Constant guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi Tag guifg=#dca3a3 guibg=NONE guisp=NONE gui=bold ctermfg=181 ctermbg=NONE cterm=bold
hi String guifg=#cc9393 guibg=NONE guisp=NONE gui=NONE ctermfg=174 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#7f7f7f guisp=#7f7f7f gui=NONE ctermfg=NONE ctermbg=8 cterm=NONE
hi Repeat guifg=#8fffff guibg=NONE guisp=NONE gui=underline ctermfg=123 ctermbg=NONE cterm=underline
hi Directory guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Structure guifg=#ffffff guibg=NONE guisp=NONE gui=bold,underline ctermfg=15 ctermbg=NONE cterm=bold,underline
hi Macro guifg=#ffcfaf guibg=NONE guisp=NONE gui=bold ctermfg=223 ctermbg=NONE cterm=bold
hi DiffAdd guifg=NONE guibg=#613c46 guisp=#613c46 gui=NONE ctermfg=NONE ctermbg=95 cterm=NONE
hi cursorim guifg=#e6e6e6 guibg=#8800ff guisp=#8800ff gui=NONE ctermfg=254 ctermbg=93 cterm=NONE
hi pythonbuiltin guifg=#6d7b7d guibg=NONE guisp=NONE gui=NONE ctermfg=66 ctermbg=NONE cterm=NONE
hi phpstringdouble guifg=#cacbcc guibg=NONE guisp=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
hi htmltagname guifg=#cacbcc guibg=NONE guisp=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
hi javascriptstrings guifg=#cacbcc guibg=NONE guisp=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
hi htmlstring guifg=#cacbcc guibg=NONE guisp=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
hi phpstringsingle guifg=#cacbcc guibg=NONE guisp=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
hi pythonimport guifg=#007700 guibg=NONE guisp=NONE gui=NONE ctermfg=2 ctermbg=NONE cterm=NONE
hi pythonexception guifg=#d60000 guibg=NONE guisp=NONE gui=NONE ctermfg=160 ctermbg=NONE cterm=NONE
hi pythonbuiltinfunction guifg=#007700 guibg=NONE guisp=NONE gui=NONE ctermfg=2 ctermbg=NONE cterm=NONE
hi pythonoperator guifg=#6a7589 guibg=NONE guisp=NONE gui=NONE ctermfg=60 ctermbg=NONE cterm=NONE
hi pythonexclass guifg=#007700 guibg=NONE guisp=NONE gui=NONE ctermfg=2 ctermbg=NONE cterm=NONE
hi mbenormal guifg=#b6a898 guibg=#2e2e3f guisp=#2e2e3f gui=NONE ctermfg=144 ctermbg=237 cterm=NONE
hi perlspecialstring guifg=#a971b7 guibg=#404040 guisp=#404040 gui=NONE ctermfg=133 ctermbg=238 cterm=NONE
hi doxygenspecial guifg=#e4bb82 guibg=NONE guisp=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
hi mbechanged guifg=#d5d5d5 guibg=#2e2e3f guisp=#2e2e3f gui=NONE ctermfg=188 ctermbg=237 cterm=NONE
hi mbevisiblechanged guifg=#d5d5d5 guibg=#4e4e8f guisp=#4e4e8f gui=NONE ctermfg=188 ctermbg=60 cterm=NONE
hi doxygenparam guifg=#e4bb82 guibg=NONE guisp=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
hi doxygensmallspecial guifg=#e4bb82 guibg=NONE guisp=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
hi doxygenprev guifg=#e4bb82 guibg=NONE guisp=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
hi perlspecialmatch guifg=#a971b7 guibg=#404040 guisp=#404040 gui=NONE ctermfg=133 ctermbg=238 cterm=NONE
hi cformat guifg=#a971b7 guibg=#404040 guisp=#404040 gui=NONE ctermfg=133 ctermbg=238 cterm=NONE
hi lcursor guifg=NONE guibg=#00ffff guisp=#00ffff gui=NONE ctermfg=NONE ctermbg=14 cterm=NONE
hi doxygenspecialmultilinedesc guifg=#945109 guibg=NONE guisp=NONE gui=NONE ctermfg=94 ctermbg=NONE cterm=NONE
hi taglisttagname guifg=#737cd4 guibg=NONE guisp=NONE gui=NONE ctermfg=104 ctermbg=NONE cterm=NONE
hi doxygenbrief guifg=#e49b57 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
hi mbevisiblenormal guifg=#b6b6b5 guibg=#4e4e8f guisp=#4e4e8f gui=NONE ctermfg=249 ctermbg=60 cterm=NONE
hi user2 guifg=#5e5e87 guibg=#3e3e5e guisp=#3e3e5e gui=NONE ctermfg=60 ctermbg=60 cterm=NONE
hi user1 guifg=#00e67f guibg=#3e3e5e guisp=#3e3e5e gui=NONE ctermfg=42 ctermbg=60 cterm=NONE
hi doxygenspecialonelinedesc guifg=#945109 guibg=NONE guisp=NONE gui=NONE ctermfg=94 ctermbg=NONE cterm=NONE
hi doxygencomment guifg=#946a1b guibg=NONE guisp=NONE gui=NONE ctermfg=94 ctermbg=NONE cterm=NONE
hi cspecialcharacter guifg=#a971b7 guibg=#404040 guisp=#404040 gui=NONE ctermfg=133 ctermbg=238 cterm=NONE
hi stringdelimiter guifg=#404d26 guibg=NONE guisp=NONE gui=NONE ctermfg=58 ctermbg=NONE cterm=NONE
hi rubyregexp guifg=#c40083 guibg=NONE guisp=NONE gui=NONE ctermfg=5 ctermbg=NONE cterm=NONE
hi string guifg=#83945b guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi constant guifg=#b65e43 guibg=NONE guisp=NONE gui=NONE ctermfg=131 ctermbg=NONE cterm=NONE
hi normal guifg=#cfcfbc guibg=#151515 guisp=#151515 gui=NONE ctermfg=187 ctermbg=233 cterm=NONE
hi rubyinstancevariable guifg=#b2a4e5 guibg=NONE guisp=NONE gui=NONE ctermfg=104 ctermbg=NONE cterm=NONE
hi rubyclass guifg=#396380 guibg=NONE guisp=NONE gui=NONE ctermfg=66 ctermbg=NONE cterm=NONE
hi identifier guifg=#b1a3d5 guibg=NONE guisp=NONE gui=NONE ctermfg=146 ctermbg=NONE cterm=NONE
hi comment guifg=#6f6f6f guibg=NONE guisp=NONE gui=italic ctermfg=242 ctermbg=NONE cterm=NONE
hi rubyregexpdelimiter guifg=#3e0049 guibg=NONE guisp=NONE gui=NONE ctermfg=53 ctermbg=NONE cterm=NONE
hi rubyregexpspecial guifg=#8b0061 guibg=NONE guisp=NONE gui=NONE ctermfg=89 ctermbg=NONE cterm=NONE
hi rubypredefinedidentifier guifg=#c54c6a guibg=NONE guisp=NONE gui=NONE ctermfg=168 ctermbg=NONE cterm=NONE
hi function guifg=#e0ba6d guibg=NONE guisp=NONE gui=NONE ctermfg=179 ctermbg=NONE cterm=NONE
hi directory guifg=#c1b876 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi rubysymbol guifg=#6986bd guibg=NONE guisp=NONE gui=NONE ctermfg=67 ctermbg=NONE cterm=NONE
hi rubycontrol guifg=#6684ad guibg=NONE guisp=NONE gui=NONE ctermfg=67 ctermbg=NONE cterm=NONE
hi rubyidentifier guifg=#b2a4e5 guibg=NONE guisp=NONE gui=NONE ctermfg=104 ctermbg=NONE cterm=NONE
hi condtional guifg=#8fffff guibg=NONE guisp=NONE gui=NONE ctermfg=123 ctermbg=NONE cterm=NONE
hi cdefine guifg=#00e6e6 guibg=NONE guisp=NONE gui=NONE ctermfg=44 ctermbg=NONE cterm=NONE
hi cinclude guifg=#e6e6e6 guibg=NONE guisp=NONE gui=NONE ctermfg=254 ctermbg=NONE cterm=NONE
hi browsedirectory guifg=#e6e600 guibg=NONE guisp=NONE gui=bold ctermfg=184 ctermbg=NONE cterm=bold
hi htm guifg=#767676 guibg=NONE guisp=NONE gui=NONE ctermfg=243 ctermbg=NONE cterm=NONE
hi js guifg=#b45050 guibg=NONE guisp=NONE gui=NONE ctermfg=131 ctermbg=NONE cterm=NONE
hi defined guifg=#cae6e6 guibg=NONE guisp=NONE gui=bold ctermfg=152 ctermbg=NONE cterm=bold
