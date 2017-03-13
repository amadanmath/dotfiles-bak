
" vim: set foldmethod=marker foldlevel=0:

set nocompatible
let mapleader      = ' '
let maplocalleader = ' '

" Install Vim-Plug if not installed already {{{
if has('vim_starting') && !filereadable(expand('~/.vim/autoload/plug.vim'))
  echo "Installing Vim-Plug\n"
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
endif
"}}}

" Plugins {{{
if plug#begin('~/.vim/plugged')
  " {{{ vim-easy-align
    " Align things [ga]
    Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
    nmap gaa ga_
  " }}}
  " {{{ peekaboo
    " Show register contents with [@] ["]
    Plug 'junegunn/vim-peekaboo'
    let g:peekaboo_delay = 750
    let g:peekaboo_compact = 1
  " }}}
  " {{{ seoul256
    " Color scheme
    Plug 'junegunn/seoul256.vim'
  " }}}
  " {{{ vim-fugitive
    " Git handling
    Plug 'tpope/vim-fugitive'
  " }}}
  " {{{ gv
    " Git/Fugitive pretty graph [:GV]
    Plug 'junegunn/gv.vim'
  " }}}
  " {{{ fzf
    " fast FuzZyFinder
    Plug 'junegunn/fzf', { 'do': './install --all' }
  " }}}
  " {{{ fzf.vim
    " fzf integration with Vim
    Plug 'junegunn/fzf.vim'
    nnoremap <silent> <Leader><Leader> :Files<CR>
    nnoremap <silent> <Leader><Enter> :Buffers<CR>
    nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
    nnoremap <silent> <Leader>q: :History:<CR>
    nnoremap <silent> <Leader>q/ :History/<CR>
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-j> <plug>(fzf-complete-file-ag)
    imap <c-x><c-l> <plug>(fzf-complete-line)
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)
  " }}}
  " {{{ vim-repeat
    " make repeat [.] more reliable
    Plug 'tpope/vim-repeat'
  " }}}
  " {{{ vim-surround
    " surround stuff
    " [cs12] - change 1 to 2
    " [ys_2] - surround object _ with 2
    " [ds1]  - delete 1
    " v:[S2] - surround visual with 2
    Plug 'tpope/vim-surround'
  " }}}
  " {{{ vim-endwise
    " insert end tags on end-using languages (Ruby, Vimscript...)
    Plug 'tpope/vim-endwise'
  " }}}
  " {{{ vim-commentary
    " comment stuff [gc_] [:Commentary]
    Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
  " }}}
  " {{{ undotree
    " navigate the undo tree
    Plug 'mbbill/undotree',             { 'on': 'UndotreeToggle'   }
    nnoremap <silent> <F6> :UndotreeToggle<CR>
  " }}}
  " {{{ splitjoin
    " split oneliners [gS] or join [gJ]
    Plug 'AndrewRadev/splitjoin.vim'
  " }}}
  " {{{ YouCompleteMe
    " tab completion
    Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp', 'javascript', 'python'], 'do': './install.py --clang-completer --tern-completer' }
    " TODO read the docs
  " }}}
  " {{{ NERDTree
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    let NERDChristmasTree = 1
    let NERDTreeQuitOnOpen = 1
    nnoremap <silent> <F2> :NERDTreeToggle<CR>
    nnoremap <silent> <S-F2> :execute "NERDTree ".expand("%:p:h")<CR>
  " }}}
  " {{{ tagbar
    " navigate project tags
    Plug 'majutsushi/tagbar'
    nnoremap <silent> <F3> :TagbarToggle<CR>
    let g:tagbar_autoclose = 1
    let g:tagbar_autofocus = 1
    let g:tagbar_sort = 0

    " gem install CoffeeTags
    if executable('coffeetags')
      let g:tagbar_type_coffee = {
            \   'ctagsbin' : 'coffeetags',
            \   'ctagsargs' : '',
            \   'kinds' : [
            \     'f:functions',
            \     'o:object',
            \   ],
            \   'sro' : ".",
            \   'kind2scope' : {
            \     'f' : 'object',
            \     'o' : 'object',
            \   }
            \ }
    endif
  " }}}
  " {{{ vim-gtfo
    " open Terminal [got] or Finder [gof] in current dir
    Plug 'justinmk/vim-gtfo'
  " }}}
  " {{{ syntastic
    " Linting
    Plug 'scrooloose/syntastic'
  " }}}
  " {{{ numbers
    " gives relative numbers in normal mode [_nn]
    Plug 'amadanmath/numbers.vim'
    nnoremap <leader>nn :NumbersToggle<CR>
  " "}}}
  " {{{ vim-neatfoldtext
    " prettify folds
    Plug 'Harenome/vim-neatfoldtext'
  " }}}
  " {{{ vim-unimpaired
    " common up-down shortcuts
    Plug 'tpope/vim-unimpaired'
  " }}}
  " {{{ vim-sleuth
    " detect indent settings automatically
    Plug 'tpope/vim-sleuth'
  " }}}
  " {{{ vim-polyglot
    " rules for many langauges
    Plug 'sheerun/vim-polyglot'
  " }}}
  " {{{ bufexplorer
    " buffer navigation
    Plug 'jlanzarotta/bufexplorer'
    let g:bufExplorerDisableDefaultKeyMapping = 1
    let g:bufExplorerShowDirectories = 0
    nnoremap <F3> :ToggleBufExplorer<CR>
  " }}}
  " {{{ ZoomWin
    " zoom or unzoom a single window as the only window [<C-W>o]
    Plug 'vim-scripts/ZoomWin'
  " }}}
  " {{{ vim-sneak
    " sneak forward/backward (2-letter F) [s__], [S__]
    Plug 'justinmk/vim-sneak'
  " }}}
  " {{{ visualrepeat
    " allow repeating with [.] in visual mode
    Plug 'vim-scripts/visualrepeat'
  " }}}
  " {{{ vim-abolish
    " coercion with [cr_], :S/child{,ren}/adult{,s}/g
    " camel, mixed, snake, uppersnake, kebab, .dot, [ ]space, title
    Plug 'tpope/vim-abolish'
  " }}}
  " {{{ vim-pairs
    " object [q] for any quotes, [ ] for any punctpair,
    " and all punctuation pairs (e.g. [*])
    Plug 'kurkale6ka/vim-pairs'
  " }}}
  " {{{ sparkup
    " zen-coding for HTML
    Plug 'rstacruz/sparkup'
  " }}}
  " {{{ LaTeX-Box
    " LaTeX helper: [[[], []]], [_lw], [_lW]
    Plug 'vim-scripts/LaTeX-Box'
    autocmd FileType tex inoremap <buffer> [[ \begin{
    autocmd FileType tex imap <buffer> ]] <Plug>LatexCloseCurEnv
    autocmd FileType tex vmap <buffer> <Leader>lw <Plug>LatexWrapSelection
    autocmd FileType tex vmap <buffer> <Leader>lW <Plug>LatexEnvWrapSelection
    let g:LatexBox_completion_close_braces = 1
    let g:tex_flavor='latex'
  " }}}
  " {{{ renamer
    " rename files :Renamer -> :w
    Plug 'qpkorr/vim-renamer'
    let g:RenamerSupportColonWToRename = 1
  " }}}
  " {{{ recover
    " ask for diff when swap is found
    Plug 'chrisbra/Recover.vim'
  " }}}
  " {{{ SyntaxAttr
    " report syntax highlighting attributes under the cursor [_sg]
    Plug 'vim-scripts/SyntaxAttr.vim'
  " }}}
  " {{{ AnsiEsc
    " display ansi escape sequences correctly
    Plug 'vim-scripts/AnsiEsc.vim'
  " }}}
  " {{{ vim-airline
    " nice status line
    Plug 'vim-airline/vim-airline'
    if exists('+guifont') && has('mac') && has('gui_running')
      " https://github.com/powerline/fonts/tree/master/SourceCodePro
      set guifont=Sauce\ Code\ Powerline:h12
      let g:airline_powerline_fonts = 1
    endif
  " }}}
endif
call plug#end()
"}}}

" {{{ Options
  set autoindent
  set smartindent
  set shiftround
  set virtualedit=block
  set nofoldenable
  set hidden
  set autowrite
  set autoread
  set nowritebackup
  set nobackup
  set lazyredraw
  set laststatus=2
  set showcmd
  set visualbell
  set backspace=indent,eol,start
  set shortmess=aTI
  set hlsearch
  set incsearch
  set wildmenu
  set wildmode=full
  set scrolloff=5
  set splitbelow
  set splitright
  set diffopt+=iwhite
  set cryptmethod=blowfish2
  set matchpairs+=<:>
  set encoding=utf-8
  set fencs=utf-8,sjis,eucjp
  set pastetoggle=<F5>
  set tags=./tags;$HOME
  set mouse-=a
  set formatoptions+=1j
  set modeline
  set modelines=2
  set history=256
  set synmaxcol=1000
  set directory=/tmp//,.
  set backupdir=/tmp//,.
  set nostartofline
  set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.aux,*.pyc

  if has("gui_running")
    set guioptions-=T
  endif
  if has('unnamedplus')
    set clipboard+=unnamedplus
  else
    set clipboard+=unnamed
  endif
  if has('settermcolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
  if has('gui_running')
    silent! colorscheme seoul256-light
  else
    silent! colorscheme seoul256
  endif
  if has("persistent_undo")
    set undodir=~/.vim/undo/
    set undofile
  endif
  runtime macros/matchit.vim
" }}}

" {{{ Mappings
  " {{{ Escape
    inoremap kj <Esc>
    xnoremap kj <Esc>
    cnoremap kj <C-c>
  " }}}
  " {{{ close quickfix/location qlist, kill search highlight, redraw [<C-L>]
    nnoremap <silent> <C-L> :nohlsearch<bar>cclose<bar>lclose<CR><C-L>
  " }}}
  " {{{ visual mode on pasted text [gp]
    nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
  " }}}
  " {{{ jump to a previous [[i] or next []i] line with the same indent
    nnoremap <silent> [i :<C-u>call search('^' .
          \ matchstr(getline(line('.') + 1), '\(\s*\)') .'\S', 'b')<CR>^
    nnoremap <silent> ]i :<C-u>call search('^' .
          \ matchstr(getline(line('.')), '\(\s*\)') .'\S')<CR>^
  " }}}
  " {{{ paste without yanking in visual mode [P]
    xnoremap <expr> P '"_d"'.v:register.'P'
  " }}}
  " {{{ insert into camelcase [_s]
    nnoremap <leader>s ~hi
  " }}}
  " {{{ show/hide foldcolumn with foldenable [zi]
    function! FoldColumn(on) " 1: on, 0: off, -1: toggle
      let was_on = &foldenable
      if a:on == 1 || (a:on == -1 && !was_on)
        setlocal foldcolumn=5
        setlocal foldenable
      else
        setlocal foldcolumn=0
        setlocal nofoldenable
      endif
      return was_on
    endfunction
    nnoremap <silent> zi :call FoldColumn(-1)<CR>
    call FoldColumn(0)
  " }}}
  " {{{ Toggle hex edit mode [_xx]
    let g:hex_mode_on = 0
    let g:hex_mode_saved_foldenable = &foldenable
    function! ToggleHex()
        if g:hex_mode_on
            execute "%!xxd -r"
            let g:hex_mode_on = 0
            call FoldColumn(g:hex_mode_saved_foldenable)
        else
            execute "%!xxd"
            let g:hex_mode_on = 1
            let g:hex_mode_saved_foldenable = FoldColumn(0)
        endif
    endfunction
    nmap <Leader>xx :call ToggleHex()<CR>
  " }}}
  " {{{ Search for selected text, forwards [*] or backwards [#]
    vnoremap <silent> * :<C-U>
        \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
        \gvy/<C-R><C-R>=substitute(
        \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
        \gV:call setreg('"', old_reg, old_regtype)<CR>
    vnoremap <silent> # :<C-U>
        \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
        \gvy?<C-R><C-R>=substitute(
        \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
        \gV:call setreg('"', old_reg, old_regtype)<CR>
  " }}}
  " {{{ make help toggle [<F1>]
    inoremap <F1> <nop>
    noremap <F1> :call MapF1()<CR>
    function! MapF1()
      if &buftype == "help"
        execute 'quit'
      else
        execute 'help'
      endif
    endfunction
  " }}}
  " {{{ rename in file
    function! RenameInFile()
      normal "zyiw
      let line_number = line('.')
      let original = @z
      let replacement = input("Replace [" . original . "] with: ", original)
      execute "%s/\\<" . original . "\\>/" . replacement . "/ceg"
      execute line_number
      let @/ = replacement
      set hls
    endfunction
    nnoremap <Leader>rn :call RenameInFile()<CR>
  " }}}
" }}}

" {{{ Autocmds
augroup vimrc
  " {{{ reload vimrc on change
    au BufWritePost .vimrc nested if expand('%') !~ 'fugitive' | source % | endif
  " }}}
  " {{{ highlight unwanted spaces
    au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
    au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/
  " }}}
  " {{{ unset paste on InsertLeave
    au InsertLeave * silent! set nopaste
  " }}}
  " {{{ check if file was changed while idle
    au CursorHold,CursorHoldI * if (&bt != 'nofile') | checktime | endif
  " }}
  " {{{ unknown file extensions
    autocmd BufRead,BufNewFile {Gemfile,Rakefile,Guardfile,Capfile,*.rake,config.ru} setlocal ft=ruby
    autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown} setlocal ft=markdown
    autocmd BufRead,BufNewFile {COMMIT_EDITMSG} setlocal ft=gitcommit
  " }}}
  " {{{ tidy up [_xt] or lint [_xl] XML
    " XXX put it into ftplugins?
    if executable('tidy')
      autocmd FileType xml nnoremap <buffer> <Leader>xt :%!tidy -q -i -utf8 -xml<CR>
      autocmd FileType xhtml nnoremap <buffer> <Leader>xt :%!tidy -q -i -utf8 -asxhtml<CR>
      autocmd FileType html nnoremap <buffer> <Leader>xt :%!tidy -q -i -utf8 -ashtml<CR>
    endif
    if executable('xmllint')
      autocmd FileType xml,xhtml nnoremap <buffer> <Leader>xl :%!xmllint --format --recover -<CR>
    endif
  " }}}
  " {{{ keep cursorline only in the current window
    set cursorline
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  " }}}
  " {{{ automatically open the quicklist on make
    autocmd QuickFixCmdPost [^l]* nested cwindow
  " }}}
augroup END
" }}}
" {{{ Commands
  " {{{ Todo
    " collect all TODO, XXX and FIXME notes
    function! s:todo() abort
      let entries = []
      for cmd in ['git grep -niI -e TODO -e FIXME -e XXX 2> /dev/null',
                \ 'grep -rniI -e TODO -e FIXME -e XXX * 2> /dev/null']
        let lines = split(system(cmd), '\n')
        if v:shell_error != 0 | continue | endif
        for line in lines
          let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
          call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
        endfor
        break
      endfor

      if !empty(entries)
        call setqflist(entries)
        copen
      endif
    endfunction
    command! Todo call s:todo()
  " }}}
  " {{{ write as sudo
    command! W exec 'w !sudo tee % > /dev/null' | e!
  " }}}
  " {{{ buffer delete without closing a window
    function! s:CustomBufferDelete(bang)
      if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        silent! execute 'bdelete' . a:bang
        return
      endif
      let current = bufnr('%')
      BufExplorer
      execute 'normal jo'
      silent! execute 'bdelete' . a:bang . ' ' . current
    endfunction
    command! -nargs=0 -bang BD call <SID>CustomBufferDelete("<bang>")
  "}}}
" }}}
>>>>>> d39d6a064870ab41b46278aad3c11a32ffc2c6e5
