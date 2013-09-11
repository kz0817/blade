" display satus line
set ts=8
set hlsearch
"set numberwidth=6
set winwidth=80

" Turn off Visual bell
"set novb

" display satus line
set laststatus=2

" display line nubmer
"set number

" unset auto indent
set noai
"set ai

" display ruler
set ruler

" Don't wrap at end of display
"set nowrap
set wrap

" Display inputing command
set showcmd

" Display corresponding ()
set showmatch

" Set locale
set termencoding=2byte-utf-8
set encoding=2byte-utf-8
set fileencodings=2byte-utf-8,2byte-sjis,2byte-euc-jp,2byte-iso-2022-jp
"set fileencodings=2byte-sjis,2byte-utf-8,2byte-iso-2022-jp,2byte-euc-jp
set ambiwidth=double

" setting for folding
set foldmethod=indent
set shiftwidth=2
set foldlevel=100
" set foldnestmax=0
set wildmode=longest:list

" Display Status line
"set statusline=%h%f%m%r%=<%l:%c>\ %y
"set statusline=(%n)\ %h%f%m%r%=%{TimeStamp()}\ %{GetStatusEx()}%y\ %03l:%02c\ 
set statusline=%4l:\ %h%f%m%r%=%{TimeStamp()}\ %{GetStatusEx()}%y\ 
" Save the cursor position in quitting
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Error format
"set efm=%f:%l:\ error:\ %m,%f:%l:\ warning:\ %m,%Dmake[%*\\d]:\ Entering\ directory\ `%f',%Xmake[%*\\d]:\ Leaving\ directory\ `%f'

" ===================================================================
" Setting about Tab
" ===================================================================
" Display Tab, and end extend line
"set listchars=tab:>-,extends:<
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
highlight SpecialKey   ctermfg=DarkGray             guifg=DarkGray             gui=NONE
highlight Delimiter    ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight String       ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight Search       ctermfg=Blue                 guifg=Blue                 gui=NONE
"highlight PreProc      ctermfg=Yellow               guifg=Yellow
"highlight Label        ctermfg=Cyan
"highlight Tag          ctermfg=Cyan
"highlight Define       ctermfg=Cyan
"highlight Keyword      ctermfg=Cyan
"highlight Macro        ctermfg=Cyan
highlight Identifier   ctermfg=None
highlight Title        ctermfg=Cyan                 guifg=Cyan                 gui=NONE
highlight Underlined   ctermfg=White cterm=Underline  guifg=White              gui=Underline

highlight LineNr       ctermfg=Yellow               guifg=Yellow
highlight Visual       ctermfg=White                guifg=White  guibg=Blue
highlight Directory    ctermfg=Cyan                 guifg=Cyan
highlight MoreMsg      ctermfg=Green                guifg=Green
highlight Question     ctermfg=Green                guifg=Green
"highlight StatusLine   cterm=Reverse ctermfg=Cyan ctermbg=White
"highlight StatusLineNC cterm=Reverse ctermfg=Blue ctermbg=White
highlight StatusLine   cterm=Reverse ctermfg=Blue ctermbg=White guifg=Blue  guibg=White gui=Reverse
highlight StatusLineNC cterm=Reverse ctermfg=Gray ctermbg=Black guifg=White guibg=Black gui=Reverse
highlight SpellErrors  ctermfg=White ctermbg=Blue   guifg=White guibg=Blue

highlight Folded       ctermfg=Cyan  ctermbg=None   guifg=Cyan

"Used in HTML syntax
highlight Underlined   ctermfg=None  cterm=None

highlight DiffAdd      ctermbg=DarkRed
highlight DiffChange   ctermbg=DarkBlue
highlight DiffText     ctermbg=DarkBlue
highlight DiffDelete   ctermbg=Black ctermfg=Gray

" ===================================================================
" Options for GVIM
" ===================================================================
" delete Tool Bar, Menu, and Scroll Bars
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L
"set guifont=TakaoGothic\ 11
set guifont=TakaoGothic\ Bold\ 10

" ===================================================================
" Auto commands
" ===================================================================
au BufNewFile,BufRead Makefile* :set shiftwidth=8
au BufNewFile,BufRead Makefile* :set noexpandtab
au BufNewFile,BufRead *.s       :set ts=4
au BufNewFile,BufRead *.s       :set noexpandtab
au BufNewFile,BufRead *.spec    :set ts=8
au BufNewFile,BufRead *.spec    :set noexpandtab
au BufNewFile,BufRead *.py      :set expandtab
au BufNewFile,BufRead *.py      :set ts=4
au BufNewFile,BufRead *.java    :set expandtab
au BufNewFile,BufRead *.java    :set ts=4
au BufNewFile,BufRead *.jsp     :set expandtab
au BufNewFile,BufRead *.jsp     :set ts=4
au BufNewFile,BufRead *.html    :set expandtab
au BufNewFile,BufRead *.html    :set ts=4
au BufNewFile,BufRead *.js      :set expandtab
au BufNewFile,BufRead *.js      :set ts=4
au BufNewFile,BufRead *.php     :set expandtab
au BufNewFile,BufRead *.php     :set ts=4
au BufNewFile,BufRead build.xml :set expandtab
au BufNewFile,BufRead build.xml :set ts=4
"autocmd BufReadPost *.tex     :setlocal spell spelllang=en_us

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
function! GetStatusEx()
  let str = ''
  let str = str . '' . &fileformat . ']'
  if has('multi_byte') && &fileencoding != ''
    let str = '[' . &fileencoding . ':' . str
  else
    let str = '[' . str
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
  "set csprg=/usr/local/bin/cscope
  "set csto=0
  "set cst
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
  "let fname = system("basename ".a:path)
  let dname = system("dirname ".a:path)

  let r = system("mkdir -p ".predir.dname)
  let cmd = "rsync -avz ".a:host."::".a:path." ".predir.a:path
  echo cmd
  "let r = system(cmd)
  let r = system(cmd)
  echo r
  exe "sp ".predir.a:path
endfunction

" ===================================================================
" for SCREEN
" ===================================================================
function SetScreenTabName(name)
  "let arg = '\033k' . a:name . '\033\\'
  "silent! exe '!echo -en "' . "$SCREEN_HOSTNAME" . arg . "\""
  silent! exe '!echo -en "' . '\033k{' . $SCREEN_HOST . a:name . '}\033\\' . "\""
endfunction

if &term =~ "screen"
  "autocmd VimLeave * call SetScreenTabName('** free **')
  "autocmd VimLeave * call SetScreenTabName('vim')
  autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | call SetScreenTabName("%") | endif 
  "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | call SetScreenTabName("{%:.}") | endif 
endi
