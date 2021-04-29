" display satus line
set ts=8
set hlsearch
"set numberwidth=6
set winwidth=80

" Turn off bell
set visualbell t_vb=

" Turn off Visual bell
"set novb

" display satus line
set laststatus=2

" display line nubmer
"set number

" unset auto indent
"set noai
set ai

" display ruler
set ruler

" search mode line
set modeline

" Don't wrap at end of display
"set nowrap
set wrap

" Display inputing command
set showcmd

" Display corresponding ()
set showmatch

" Incrementtal search
set incsearch

" Automatically read the updated files
set autoread

" Set locale
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set ambiwidth=double

" setting for folding
set foldmethod=indent
set shiftwidth=4
set foldlevel=100
" set foldnestmax=0
set wildmenu
set wildmode=longest:list,full

set completeopt=menu

" Display Status line
set statusline=%!GetFileColor()
" Save the cursor position in quitting
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" ===================================================================
" Setting about Tab
" ===================================================================
" Display Tab, and end extend line
set listchars=tab:>-,extends:<,trail:_
set list

set noexpandtab

" ===================================================================
" Setting for syntax highlighting
" ===================================================================
if has('gui_running')
  gui
  set columns=80
  set lines=30
endif
syntax enable

" Syntax elements
highlight Normal                                    guifg=White  guibg=Black   gui=NONE
highlight Constant     ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight Error        ctermfg=White   ctermbg=Red  guifg=White  guibg=Red     gui=NONE
highlight Special      ctermfg=Yellow               guifg=Yellow               gui=NONE
highlight Comment      ctermfg=Green                guifg=#00ff00              gui=NONE
highlight Statement    ctermfg=Yellow               guifg=Yellow               gui=NONE
highlight Type         ctermfg=Yellow               guifg=Yellow               gui=NONE
highlight Preproc      ctermfg=Yellow               guifg=Yellow               gui=NONE
highlight Function     ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight SpecialKey   ctermfg=242                  guifg=DarkGray             gui=NONE
highlight Delimiter    ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight String       ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight Search       ctermfg=Black ctermbg=226    guifg=Blue                 gui=NONE
"highlight PreProc      ctermfg=Yellow               guifg=Yellow
"highlight Label        ctermfg=Cyan
"highlight Tag          ctermfg=Cyan
"highlight Define       ctermfg=Cyan
"highlight Keyword      ctermfg=Cyan
"highlight Macro        ctermfg=Cyan
highlight Identifier   ctermfg=Yellow               guifg=Yellow               gui=NONE
highlight Title        ctermfg=81 ctermbg=none     guifg=Cyan                 gui=NONE
highlight link SpecialComment Comment
highlight WildMenu     ctermfg=Black ctermbg=214

highlight LineNr       ctermfg=214  ctermbg=none     guifg=Yellow
highlight CursorLineNr cterm=underline ctermfg=220  ctermbg=none     guifg=Yellow
highlight CursorLine   cterm=underline ctermfg=none ctermbg=none

highlight Visual       ctermfg=19 ctermbg=251       guifg=White  guibg=Blue
highlight Directory    ctermfg=Cyan                 guifg=Cyan
highlight ModeMsg      ctermfg=214                  guifg=Yellow
highlight MoreMsg      ctermfg=Green                guifg=Green
highlight Question     ctermfg=Green                guifg=Green
highlight StatusLine   cterm=None ctermfg=214 ctermbg=235
highlight StatusLineNC cterm=None ctermfg=233 ctermbg=233
highlight link StatusLineTerm   StatusLine
highlight link StatusLineTermNC StatusLineNC
highlight VertSplit    cterm=None ctermfg=233 ctermbg=233

highlight SpellBad     ctermfg=White ctermbg=Red  guifg=White guibg=Red
highlight SpellCap     ctermfg=White ctermbg=163  guifg=White guibg=Blue
highlight SpellRare    ctermfg=White ctermbg=214  guifg=White guibg=Yellow
highlight SpellLocal   ctermfg=White ctermbg=214  guifg=White guibg=Yellow

highlight MatchParen   ctermfg=White ctermbg=88
highlight Folded       ctermfg=246   ctermbg=None guifg=Cyan
highlight Terminal     ctermfg=white ctermbg=232
highlight QuickFixLine cterm=none ctermfg=Black ctermbg=254
highlight TODO         ctermfg=Green ctermbg=Black

highlight Pmenu        ctermfg=254 ctermbg=237
highlight PmenuSel     ctermfg=White ctermbg=27
highlight PmenuSbar    ctermbg=240
highlight PmenuThumb   ctermbg=234

"Used in HTML syntax
highlight Underlined   ctermfg=White cterm=Underline  guifg=White              gui=Underline
highlight htmlEndTag   ctermfg=Cyan                 guifg=Cyan                 gui=NONE

highlight DiffAdd      ctermbg=22
highlight DiffText     ctermfg=0 ctermbg=82
highlight DiffChange   ctermbg=22
highlight DiffDelete   ctermfg=124 ctermbg=124

"Used in JavaScript
highlight javaScript   ctermfg=White                guifg=White                gui=NONE
highlight javaScriptBraces  ctermfg=White           guifg=White                gui=NONE

highlight TabLine      cterm=None ctermfg=252 ctermbg=235
highlight TabLineSel   cterm=None ctermfg=254 ctermbg=25
highlight TabLineFill  cterm=None ctermfg=252 ctermbg=235

" ===================================================================
" Options for GVIM
" ===================================================================
" delete Tool Bar, Menu, and Scroll Bars
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L
if !has('gui_macvim')
  "set guifont=TakaoGothic\ 11
  set guifont=TakaoGothic\ Bold\ 10
else
  set guifont=Takaoゴシック:h12
endif

" ===================================================================
" Auto commands
" ===================================================================
augroup mine
  " Remove all registered auto commands for reloading .vimrc
  autocmd!

  au BufNewFile,BufRead Makefile* :set shiftwidth=8
  au BufNewFile,BufRead Makefile* :set noexpandtab
  au BufNewFile,BufRead *.s       :set ts=4
  au BufNewFile,BufRead *.s       :set noexpandtab
  au BufNewFile,BufRead *.spec    :set ts=8
  au BufNewFile,BufRead *.spec    :set noexpandtab
  au BufNewFile,BufRead *.h,*.hpp,*.c,*.cpp,*.cc,*.java set expandtab ts=4 winwidth=100
  au BufNewFile,BufRead *.cu      :set expandtab
  au BufNewFile,BufRead *.cu      :set ts=4
  au BufNewFile,BufRead *.py      :set expandtab
  au BufNewFile,BufRead *.py      :set ts=4
  au BufNewFile,BufRead *.scala   :set expandtab
  au BufNewFile,BufRead *.scala   :set ts=2
  au BufNewFile,BufRead *.kt      :set expandtab
  au BufNewFile,BufRead *.kt      :set ts=4
  au BufNewFile,BufRead *.jsp     :set expandtab
  au BufNewFile,BufRead *.jsp     :set ts=4
  au BufNewFile,BufRead *.html    :set expandtab
  au BufNewFile,BufRead *.html    :set ts=4
  au BufNewFile,BufRead *.js      :set expandtab
  au BufNewFile,BufRead *.js      :set ts=4
  au BufNewFile,BufRead *.php     :set expandtab
  au BufNewFile,BufRead *.php     :set ts=4
  au BufNewFile,BufRead *.go      :set expandtab
  au BufNewFile,BufRead *.go      :set ts=4
  au BufNewFile,BufRead build.xml :set expandtab
  au BufNewFile,BufRead build.xml :set ts=4
  "autocmd BufReadPost *.tex     :setlocal spell spelllang=en_us

  au WinEnter * setlocal statusline=%!SetStatusLine('on')
  au WinLeave * setlocal statusline=%!SetStatusLine('off')
augroup END
set statusline=%!SetStatusLine('on')

" ===================================================================
" Key mapping
" ===================================================================
map <Left>  <Nop>
map <Right> <Nop>
map <Up>    <Nop>
map <Down>  <Nop>
"map <Esc>   <Nop>

" ===================================================================
" Functions
" ===================================================================
highlight ActiveSLPath     cterm=None ctermfg=25  ctermbg=255
highlight InactiveSLPath   cterm=None ctermfg=233 ctermbg=250

highlight ActiveSLAttr     cterm=None ctermfg=0   ctermbg=214
highlight InactiveSLAttr   cterm=None ctermfg=0   ctermbg=254

highlight ActiveSLBase     cterm=None ctermfg=15  ctermbg=25
highlight InactiveSLBase   cterm=None ctermfg=15  ctermbg=238

highlight ActiveSLFmt      cterm=None ctermfg=159 ctermbg=25
highlight InactiveSLFmt    cterm=None ctermfg=253 ctermbg=238

highlight ActiveSLType     cterm=None ctermfg=159 ctermbg=32
highlight InactiveSLType   cterm=None ctermfg=15  ctermbg=242

highlight ActiveSLPos      cterm=None ctermfg=233 ctermbg=81
highlight InactiveSLPos    cterm=None ctermfg=234 ctermbg=250

function! SetStatusLine(mode)
  if a:mode == 'on'
    let c_path = '%#ActiveSLPath#'
    let c_attr = '%#ActiveSLAttr#'
    let c_base = '%#ActiveSLBase#'
    let c_fmt  = '%#ActiveSLFmt#'
    let c_type = '%#ActiveSLType#'
    let c_pos  = '%#ActiveSLPos#'
  else
    let c_path = '%#InactiveSLPath#'
    let c_attr = '%#InactiveSLAttr#'
    let c_base = '%#InactiveSLBase#'
    let c_fmt  = '%#InactiveSLFmt#'
    let c_type = '%#InactiveSLType#'
    let c_pos  = '%#InactiveSLPos#'
  endif
  let sl = ''
  let sl = sl . c_path . ' %h%f '
  let sl = sl . c_attr . '%m%r'
  let sl = sl . c_base . '%='
  let sl = sl . c_fmt  . ' %{GetStatusEx()}'
  let sl = sl . c_type . ' %Y '
  let sl = sl . c_pos  . ' %4l:%-3c'
  return sl
endfunction

function! GetStatusEx()
  let str = &fileformat . ' '
  if has('multi_byte') && &fileencoding != ''
    let str = '' . &fileencoding . ':' . str
  else
    let str = '' . str
  endif
  return str
endfunction

function! TimeStamp()
  let str = ''
  let ftim = getftime(bufname("%"))
  let ctim = localtime()
  if ftim >= 0
    if ctim - ftim < 365 * 24 * 3600
      let str = '<' . strftime("%m/%d %H:%M", ftim ) . '>'
    else
      let str = '<' . strftime("%Y/%m/%d", ftim ) . '>'
    endif
  endif
  return str
endfunction

" ===================================================================
" for cscope
" ===================================================================
if has("cscope")
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
  " else add database pointed to by environment 
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
  "set cscopequickfix=s-,c-,d-,i-,t-,e-
  nmap <C-]>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-]><C-]>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-]>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-]><C-]>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-]>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-]><C-]>e :scs find e <C-R>=expand("<cword>")<CR><CR>
endif

" ===================================================================
" for VimSpell
" ===================================================================
highlight SpellErrors ctermfg=yellow ctermbg=Red
let spell_auto_type = "tex,mail,text"

" ===================================================================
" Set for indivisual setting
" ===================================================================
let fread = filereadable("~/.vimrc.local")
if fread > 0
  source ~/.vimrc.local
endif

let fread = filereadable("__vimrc")
if fread > 0
  source __vimrc
endif

" ===================================================================
" for vimgdb
" ===================================================================
highlight gdb_bp       ctermfg=none ctermbg=blue
highlight gdb_dbp      ctermfg=white ctermbg=green
highlight gdb_fr       ctermfg=none  ctermbg=red

" ===================================================================
" rsync
" ===================================================================
function! Re(host,path)
  let predir = "/tmp/netsync/"
  let dname = system("dirname ".a:path)

  let r = system("mkdir -p ".predir.dname)
  let cmd = "rsync -avz ".a:host."::".a:path." ".predir.a:path
  echo cmd
  let r = system(cmd)
  echo r
  exe "sp ".predir.a:path
endfunction

" ===================================================================
" for SCREEN
" ===================================================================
function! SetScreenTabName()
  let l:bufname = bufname("")
  if l:bufname != ""
    silent! exe '!echo -en "' . '\033k' . $SCREEN_HOST . '{' . l:bufname . '}\033\\' . "\""
  endif
endfunction

if &term =~ "screen"
  augroup mine | autocmd BufEnter * if bufname("") != "" | call SetScreenTabName() | endif | augroup END
endi

