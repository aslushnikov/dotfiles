" removing compatibility with Vi
set nocompatible

" Remove any trailing whitespace that is in the file
"autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" highlight current line
"set cul
"hi CursorLine term=none cterm=none ctermbg=3
"
" Internal vim mapping for russian language
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=-1
" Change vim language mapping via C-l instead of default C-^
inoremap <c-l> <c-^>

" fast TTY repaint
set ttyfast

" remove 2 seconds timeout for escape key
set ttimeout ttimeoutlen=0

" setting up window title
set title
set titlestring=%F\ %m

" allow backspace to delete all kind of characters
set backspace+=start,eol,indent

" display trailing spaces with "~" and tabs with "->"
set list
set listchars=tab:<-,trail:~

" look in the current directory for "tags", and work up the tree towards root
" until one is found.
set tags=./.tags;/

" setup the max length of a line
" set textwidth=80
"
" display current command in the bottom-right corner
set showcmd

" always dislpay 20 lines before and after cursor if possible
set scrolloff=20

" insert apropriate amount of spaces when tab's hit
set expandtab
" number of spaces to use for each step of indent
set shiftwidth=4
" amount of spaces to insert when one hits tab
set softtabstop=4

" search ignores case iff pattern is in a lower case
set smartcase
set ignorecase

" convenient indenting
set autoindent

" line numbers
set number

" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" Status line gnarliness
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" Paste Mode!  Dang! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>

" convenient switching between tabs
map <F3> gT
map <F4> gt

" go to header/source files
map <F5> :e %:p:s,.h$,.X123X,:s,.m$,.h,:s,.X123X$,.m,<CR>

" Centering screen when jumping through search results
map N Nzz
map n nzz
map * *zz
map # #zz
imap <F3> <ESC>gTi
imap <F4> <ESC>gti

" Rotate Color Scheme <F8>
nnoremap <silent> <F8> :execute RotateColorTheme()<CR>

" Moving around screen lines, not physical lines
noremap k gk
noremap j gj

syntax on
filetype plugin on

" Colors for complete options popup
hi Pmenu      ctermfg=Cyan    ctermbg=Blue cterm=None guifg=Cyan guibg=DarkBlue
hi PmenuSel   ctermfg=White   ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold
hi PmenuSbar                  ctermbg=Cyan            guibg=Cyan
hi PmenuThumb ctermfg=white                           guifg=White

"================================================
"================================================
"        OMG one can program for vim...
"================================================
"================================================
"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
   if g:paste_mode == 0
      set paste
      let g:paste_mode = 1
   else
      set nopaste
      let g:paste_mode = 0
   endif
   return
endfunc
"}}}

"{{{Theme Rotating
let themeindex=0
function! RotateColorTheme()
   let y = -1
   while y == -1
      let colorstring = "inkpot#ron#blue#elflord#evening#koehler#murphy#pablo#desert#torte#"
      let x = match( colorstring, "#", g:themeindex )
      let y = match( colorstring, "#", x + 1 )
      let g:themeindex = x + 1
      if y == -1
         let g:themeindex = 0
      else
         let themestring = strpart(colorstring, x + 1, y - x - 1)
         return ":colorscheme ".themestring
      endif
   endwhile
endfunction

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END

