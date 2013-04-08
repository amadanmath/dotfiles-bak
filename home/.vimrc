" General "{{{
  set nocompatible
  set history=256
  set autowrite
  set autoread
  set clipboard+=unnamed
  set pastetoggle=<f5>
  set tags=./tags;$HOME
  set encoding=utf-8
  set virtualedit=block
  set matchpairs+=<:>
  " Modeline
  set modeline
  set modelines=5
  " Backup
  set nowritebackup
  set nobackup
  set directory=./tmp//,/var/tmp//,/tmp//
  " Completion
  set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.aux
  " Buffers
  set hidden
  " Match and search
  set hlsearch
  set incsearch
  set fencs=utf-8,sjis,euc-jp
" "}}}

" Formatting "{{{
  set formatoptions+=cqro
  set formatoptions-=t

  set nowrap
  set textwidth=72
  set wildmode=list:longest,list:full
  set wildmenu

  set backspace=indent,eol,start

  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  set smarttab

  set autoindent
  set cinoptions=:s,ps,ts,cs
  set cinwords=if,else,while,do,for,switch,case
" "}}}

" Visual "{{{
  set background=dark
  set showmatch
  set matchtime=5
  set novisualbell
  set noerrorbells
  set laststatus=2
  set vb t_vb= " no beeps or flashes on error
  set showcmd
  set shortmess=atI
  set scrolloff=5

  set nolist
  set listchars=tab:·\ ,eol:¶,trail:·,extends:»,precedes:«

  set mouse-=a
  set mousehide

  set splitbelow
  set splitright

  if has("gui_running")
    set guioptions-=T
  endif
" "}}}

" Grep "{{{
  let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git generated'
  set grepprg=/bin/grep\ -nH
" "}}}

" Command and Auto commands "{{{
  " Sudo write
  command! W exec 'w !sudo tee % > /dev/null' | e!

  " unknown file extensions
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,Guardfile,Capfile,*.rake,config.ru} setlocal ft=ruby
  autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown} setlocal ft=markdown
  autocmd BufRead,BufNewFile {COMMIT_EDITMSG} setlocal ft=gitcommit

  " restore cursor position on vim load
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

  " tidy up XML XXX put it into ftplugins
  autocmd FileType xml,xhtml nnoremap <buffer> <leader>x :%!tidy -q -i -utf8 -xml<CR>

  " keep a cursor line in the current window only
  set cursorline
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " automatically open the quicklist on make
  autocmd QuickFixCmdPost [^l]* nested cwindow
  " autocmd QuickFixCmdPost    l* nested lwindow
" "}}}

" Key mappings "{{{
  " remove highlights with redraw
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

  " visual mode on pasted text
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

  " paste without yanking in visual mode
  xnoremap <expr> P '"_d"'.v:register.'P'

  " show/hide foldcolumn with foldenable
  function! FoldColumnToggle()
    if &foldcolumn == 0
      setlocal foldcolumn=5
      setlocal foldenable
    else
      setlocal foldcolumn=0
      setlocal nofoldenable
    endif
  endfunction
  nnoremap <silent> zi :call FoldColumnToggle()<CR>
  set foldmethod=marker
  set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
  set nofoldenable

  " Search for selected text, forwards or backwards.
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

  " help toggle
  inoremap <F1> <nop>
  noremap <F1> :call MapF1()<CR>
  function! MapF1()
    if &buftype == "help"
      execute 'quit'
    else
      execute 'help'
    endif
  endfunction

  " paste, increment, yank again (debug statements)
  nnoremap <leader>y p<C-A>==yy

  " parameter reordering
  function! ReorderParams(params)
    let oldz = @z
    normal "zdi(
    let params = split(a:params, ',\s')
    let order = input(string(map(copy(params), 'v:key + 1 . ": " . v:val')))
    let @z = join(map(split(order, '[0-9]\zs'), 'params[str2nr(v:val) - 1]'), ', ')
    normal "zP
    let @z = oldz
  endfunction
  nnoremap <leader>z "zdi(:call ReorderParams(@z)<CR>

  " rename in file
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
  nnoremap <leader>r :call RenameInFile()<CR>

  " find merge conflicts
  nnoremap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

  " compensate for way too tiny escape key on mac air
  inoremap kj <Esc>

  " make arrows move through windows
  nnoremap <Left> <C-W>h
  nnoremap <Down> <C-W>j
  nnoremap <Up> <C-W>k
  nnoremap <Right> <C-W>l
  inoremap <Left> <Nop>
  inoremap <Down> <Nop>
  inoremap <Up> <Nop>
  inoremap <Right> <Nop>
" "}}}

" MacVim specific stuff "{{{
  if has('gui_macvim')
    " set guifont=Monaco:h10
    " set noantialias
    nnoremap <silent> <SwipeLeft> :macaction _cycleWindowsBackwards:<CR>
    nnoremap <silent> <SwipeRight> :macaction _cycleWindows:<CR>
    au FocusLost * :set transp=40
    au FocusGained * :set transp=10
    set transp=10
  endif
" "}}}

" Plugins "{{{
  " Vundle "{{{
    filetype off
    set runtimepath+=~/.vim/bundle/vundle/
    call vundle#rc()
    Bundle "gmarik/vundle"
  " "}}}

  " Appearance "{{{
    Bundle "nanotech/jellybeans.vim"
      colorscheme jellybeans
      let g:jellybeans_overrides = {
        \    'Todo': { 'guifg': '900000', 'guibg': 'f0f000',
        \              'ctermfg': 'Red', 'ctermbg': 'Yellow',
        \              'attr': 'bold' },
        \}
    Bundle "dickeyxxx/status.vim"
      " adds a helpful status line (depends on syntastic)
    Bundle "molok/vim-smartusline"
      " colors the status line
    Bundle "amadanmath/numbers.vim"
      " gives relative numbers in normal mode
  " "}}}

  " Buffer Navigation "{{{
    Bundle "scrooloose/nerdtree"
      let NERDChristmasTree = 1
      let NERDTreeQuitOnOpen = 1
      nnoremap <silent> <F2> :NERDTreeToggle<CR>
      nnoremap <silent> <S-F2> :execute "NERDTree ".expand("%:p:h")<CR>

    Bundle "amadanmath/bufexplorer.zip"
      nnoremap <unique> <F3> :BufExplorerToggle<CR>

    Bundle "majutsushi/tagbar"
      nnoremap <script> <silent> <unique> <F4> :TagbarToggle<CR>
      let g:tagbar_autoclose = 1
      let g:tagbar_autofocus = 1
      let g:tagbar_sort = 0
      if executable('coffeetags')
        let g:tagbar_type_coffee = {
          \   'ctagsbin' : 'coffeetags',
          \   'ctagsargs' : '--include-vars',
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

    Bundle "kien/ctrlp.vim"
      let g:ctrlp_map = '<leader>^'
      " (project home)
      let g:ctrlp_working_path_mode = 2
      let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn\|data$',
        \ 'file': '\.so$',
        \ }

    Bundle "vim-scripts/ZoomWin"
      " <C-W>o
    
    Bundle "Lokaltog/vim-easymotion.git"
  " "}}}
  
  " Editing "{{{
    Bundle "tpope/vim-repeat"
    Bundle "tpope/vim-unimpaired"
      " [, ] with many many actions
    Bundle "edsono/vim-matchit"
      " better % (g%, a%, [%, ]%)
    Bundle "tpope/vim-surround"
      " ys"'... TODO: look up
    Bundle "tpope/vim-speeddating"
      " enhances <C-A>, <C-X>

    Bundle "kana/vim-textobj-user"
      " library for vim-textobj-rubyblock
    Bundle "nelstrom/vim-textobj-rubyblock"
      " r = ruby block (ar, ir)
    Bundle "amadanmath/Parameter-Text-Objects"
      " P = parameter (aP, iP)

    Bundle "tomtom/tcomment_vim"
      " <C-_> is the commenting prefix

    Bundle "scrooloose/syntastic"
      " checks syntax on save
    Bundle "henrik/vim-indexed-search"
      " shows search index/position (also, g/)
    Bundle "vim-scripts/file-line"
      " opening file:line:column works
  " "}}}
  
  " Completion "{{{
    Bundle "Valloric/YouCompleteMe"
      " automatic completions
      let g:ycm_key_invoke_completion = '<C-N>'
    " Bundle "gmarik/snipmate.vim"
  " "}}}
  
  " Git "{{{
    Bundle "tpope/vim-fugitive"
      " :Git ...
      autocmd BufReadPost fugitive://* set bufhidden=delete
      function! Gdifff()
        nnoremap <buffer> dk :diffget //1<CR>
        nnoremap <buffer> dh :diffget //2<CR>
        nnoremap <buffer> dl :diffget //3<CR>
        nnoremap <buffer> dj :diffupdate<CR>
        execute "Gdiff :1"
        execute "Gdiff :2"
        execute "Gdiff :3"
      endfunction
      command! Gdifff call Gdifff()
    Bundle "int3/vim-extradite"
      " :Extradite
    Bundle "mattn/gist-vim.git"
      " :Gist -p
  " "}}}

  " Ruby "{{{
    " Bundle "astashov/vim-ruby-debugger"
      " :RDebugger
    Bundle "tpope/vim-endwise"
      " automatic "end" addition
    Bundle "tpope/vim-rails"
      " :Rscript...
  " "}}}
  
  " Go-Lang "{{{
    Bundle "jnwhiteh/vim-golang"
  " "}}}

  " JavaScript "{{{
    Bundle "vim-scripts/jQuery"

    Bundle "lukaszb/vim-web-indent"
      let g:js_indent_log = 0

    Bundle "kchmck/vim-coffee-script.git"
  " "}}}

  " LaTeX "{{{
    Bundle "vim-scripts/LaTeX-Box"
      autocmd FileType tex inoremap <buffer> [[ \begin{
      autocmd FileType tex imap <buffer> ]] <Plug>LatexCloseCurEnv
      autocmd FileType tex vmap <buffer> <Leader>lw <Plug>LatexWrapSelection
      autocmd FileType tex vmap <buffer> <Leader>lW <Plug>LatexEnvWrapSelection
      let g:LatexBox_completion_close_braces = 1
      let g:tex_flavor='latex'
  " "}}}
  
  " HTML "{{{
    Bundle "tpope/vim-markdown"
    Bundle "tpope/vim-haml"
    Bundle "tpope/vim-ragtag"
    Bundle "rstacruz/sparkup", {'rtp': 'vim/'}
    Bundle 'gregsexton/MatchTag'
  " "}}}

  " Database "{{{
    Bundle "vim-scripts/dbext.vim"
      " :h dbext-tutorial
  " "}}}

  " Tools "{{{
    Bundle "vim-scripts/Conque-Shell"
      " :ConqueTerm
    Bundle "vim-scripts/renamer.vim"
      " :Renamer
    Bundle "mileszs/ack.vim"
      " :Ack [opts] pattern [dir]
    Bundle "Shebang"
      nnoremap <leader>X :w<CR>:call SetExecutable()<CR>
  " "}}}
  
  " Various "{{{
    Bundle "amadanmath/amadan.vim"
  " "}}}

  " OS X "{{{
    Bundle "sjl/vitality.vim"
      " make vim behave with iTerm2 and tmux
  " }}}
" "}}}

" Filetype "{{{
  filetype plugin indent on
  syntax on
" "}}}
