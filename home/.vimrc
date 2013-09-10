" General "{{{
  set nocompatible
  set history=256
  set autowrite
  set autoread
  set clipboard+=unnamed
  set pastetoggle=<F5>
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

  function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = split(filter(split(&fillchars, ','), 'v:val =~# "fold"')[0], ':')[-1]
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let length = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g'))
    return foldtextstart . repeat(foldchar, winwidth(0)-length) . foldtextend
  endfunction
  set foldtext=NeatFoldText()
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
  endif
" "}}}

" Local vimrc "{{{
  if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
  endif
" "}}}

" Plugins "{{{
  " Vundle "{{{
    filetype off
    if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#rc(expand('~/.vim/bundle/'))
    NeoBundleFetch "Shougo/neobundle.vim"
  " "}}}

  " Asynchronous processing "{{{
    " XXX NeoBundle "Shougo/vimproc"
    " XXX NeoBundle "tpope/vim-dispatch"
  " "}}}

  " Appearance "{{{
    NeoBundle "nanotech/jellybeans.vim"
      colorscheme jellybeans
      let g:jellybeans_overrides = {
        \    'Todo': { 'guifg': '900000', 'guibg': 'f0f000',
        \              'ctermfg': 'Red', 'ctermbg': 'Yellow',
        \              'attr': 'bold' },
        \}
    NeoBundle "itchyny/lightline.vim" "{{{
      " adds a helpful status line (depends on syntastic)
      if exists('g:powerline_font') && exists('+guifont')
        let &guifont=g:powerline_font
        let g:powerline_chars = {
          \ 'branch[':"\ue0a0 ",
          \ 'branch]':"",
          \ 'ln':"\ue0a1",
          \ 'lock':"\ue0a2",
          \ '>black':"\ue0b0",
          \ '>':"\ue0b1",
          \ '<black':"\ue0b2",
          \ '<':"\ue0b3",
          \ }
      else
        let g:powerline_chars = {
          \ 'branch[':"[",
          \ 'branch]':"]",
          \ 'ln':"",
          \ 'lock':"\u00ae",
          \ '>black':"",
          \ '>':">",
          \ '<black':"",
          \ '<':"<",
          \ }
      endif

      let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
            \   'right': [[ 'lineinfo', 'syntastic' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype']]
            \ },
            \ 'component_function': {
            \   'fugitive': 'MyFugitive',
            \   'filename': 'MyFilename',
            \   'fileformat': 'MyFileformat',
            \   'filetype': 'MyFiletype',
            \   'fileencoding': 'MyFileencoding',
            \   'mode': 'MyMode',
            \   'syntastic': 'SyntasticStatuslineFlag',
            \   'ctrlpmark': 'CtrlPMark',
            \ },
            \ 'separator': { 'left': g:powerline_chars['>black'], 'right': g:powerline_chars['<black'] },
            \ 'subseparator': { 'left': g:powerline_chars['>'], 'right': g:powerline_chars['<'] }
            \ }
      
      function! MyModified()
        return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
      endfunction
      
      function! MyReadonly()
        return &ft !~? 'help' && &readonly ? g:powerline_chars['lock'] : ''
      endfunction
      
      function! MyFilename()
        let fname = expand('%:t')
        return fname == 'ControlP' ? g:lightline.ctrlp_item :
              \ fname == '__Tagbar__' ? g:lightline.fname :
              \ fname =~ '__Gundo\|NERD_tree\|\[BufExplorer\]' ? '' :
              \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
              \ &ft == 'unite' ? unite#get_status_string() :
              \ &ft == 'vimshell' ? vimshell#get_status_string() :
              \ &ft == 'undotree' ? '' :
              \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
              \ ('' != fname ? fname : '[No Name]') .
              \ ('' != MyModified() ? ' ' . MyModified() : '')
      endfunction
      
      function! MyFugitive()
        try
          if expand('%:t') !~? 'Tagbar\|Gundo\|NERD\|undotree' && &ft !~? 'vimfiler' && exists('*fugitive#head')
            let mark = ''  " edit here for cool mark
            let _ = fugitive#head()
            return strlen(_) ? g:powerline_chars['branch['].fugitive#head().g:powerline_chars['branch]'] : ''
          endif
        catch
        endtry
        return ''
      endfunction
      
      function! MyFileformat()
        return winwidth('.') > 70 ? &fileformat : ''
      endfunction
      
      function! MyFiletype()
        return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
      endfunction
      
      function! MyFileencoding()
        return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
      endfunction
      
      function! MyMode()
        let fname = expand('%:t')
        return fname == '__Tagbar__' ? 'Tagbar' :
              \ fname == 'ControlP' ? 'CtrlP' :
              \ fname == '__Gundo__' ? 'Gundo' :
              \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
              \ fname =~ 'NERD_tree' ? 'NERDTree' :
              \ fname == '[BufExplorer]' ? 'BufExplorer' :
              \ &ft == 'unite' ? 'Unite' :
              \ &ft == 'undotree' ? 'UndoTree' :
              \ &ft == 'vimfiler' ? 'VimFiler' :
              \ &ft == 'vimshell' ? 'VimShell' :
              \ winwidth('.') > 60 ? lightline#mode() : ''
      endfunction
      
      function! CtrlPMark()
        if expand('%:t') =~ 'ControlP'
          call lightline#link('iR'[g:lightline.ctrlp_regex])
          return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                \ , g:lightline.ctrlp_next], 0)
        else
          return ''
        endif
      endfunction
      
      let g:ctrlp_status_func = {
        \ 'main': 'CtrlPStatusFunc_1',
        \ 'prog': 'CtrlPStatusFunc_2',
        \ }
      
      function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
        let g:lightline.ctrlp_regex = a:regex
        let g:lightline.ctrlp_prev = a:prev
        let g:lightline.ctrlp_item = a:item
        let g:lightline.ctrlp_next = a:next
        return lightline#statusline(0)
      endfunction
      
      function! CtrlPStatusFunc_2(str)
        return lightline#statusline(0)
      endfunction
      
      let g:tagbar_status_func = 'TagbarStatusFunc'
      
      function! TagbarStatusFunc(current, sort, fname, ...) abort
          let g:lightline.fname = a:fname
        return lightline#statusline(0)
      endfunction
      
      let g:unite_force_overwrite_statusline = 0
      let g:vimfiler_force_overwrite_statusline = 0
      let g:vimshell_force_overwrite_statusline = 0
    "}}}
    NeoBundle "amadanmath/numbers.vim"
      " gives relative numbers in normal mode
  " "}}}

  " Buffer Navigation "{{{
    NeoBundle "scrooloose/nerdtree"
      let NERDChristmasTree = 1
      let NERDTreeQuitOnOpen = 1
      nnoremap <silent> <F2> :NERDTreeToggle<CR>
      nnoremap <silent> <S-F2> :execute "NERDTree ".expand("%:p:h")<CR>

    NeoBundle "amadanmath/bufexplorer.zip"
      nnoremap <unique> <F3> :BufExplorerToggle<CR>

    NeoBundle "majutsushi/tagbar"
      nnoremap <script> <silent> <unique> <F4> :TagbarToggle<CR>
      let g:tagbar_autoclose = 1
      let g:tagbar_autofocus = 1
      let g:tagbar_sort = 0

      " gem install CoffeeTags
      if executable('coffeetags')
        let g:tagbar_type_coffee = {
              \ 'ctagsbin' : 'coffeetags',
              \ 'ctagsargs' : '',
              \ 'kinds' : [
              \ 'f:functions',
              \ 'o:object',
              \ ],
              \ 'sro' : ".",
              \ 'kind2scope' : {
              \ 'f' : 'object',
              \ 'o' : 'object',
              \ }
              \ }
      endif

    NeoBundle "kien/ctrlp.vim"
      let g:ctrlp_map = '<leader>^'
      " (project home)
      let g:ctrlp_working_path_mode = 2
      let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn\|data$',
        \ 'file': '\.so$',
        \ }

    NeoBundle "vim-scripts/ZoomWin"
      " <C-W>o
    
    NeoBundle "Lokaltog/vim-easymotion.git"
  " "}}}
  
  " Editing "{{{
    NeoBundle "tpope/vim-repeat"
    NeoBundle "tpope/vim-abolish"
    NeoBundle "tpope/vim-unimpaired"
      " [, ] with many many actions
    NeoBundle "edsono/vim-matchit"
      " better % (g%, a%, [%, ]%)
    NeoBundle "kurkale6ka/vim-pairs"
      " better text objects for punct, and "q" for quotes
    NeoBundle "tpope/vim-surround"
      " ys"'... TODO: look up
    NeoBundle "tpope/vim-speeddating"
      " enhances <C-A>, <C-X>

    NeoBundle "kana/vim-textobj-user"
      " library for vim-textobj-rubyblock
    NeoBundle "nelstrom/vim-textobj-rubyblock"
      " r = ruby block (ar, ir)
    NeoBundle "amadanmath/Parameter-Text-Objects"
      " P = parameter (aP, iP)

    " XXX NeoBundle "tpope/vim-commentary"
      " gc<motion> comments and toggles, gcu uncomments

    NeoBundle "scrooloose/syntastic"
      " checks syntax on save
    NeoBundle "henrik/vim-indexed-search"
      " shows search index/position (also, g/)
    NeoBundle "vim-scripts/file-line"
      " opening file:line:column works
    NeoBundle "mbbill/undotree"
      nnoremap <F6> :UndotreeToggle<CR>
      if has("persistent_undo")
        set undodir="~/.vim/undo"
        set undofile
      endif
  " "}}}
  
  " Completion "{{{
    " XXX NeoBundle "Shougo/unite.vim"
    " NeoBundle "Valloric/YouCompleteMe"
      " automatic completions
      " let g:ycm_key_invoke_completion = '<C-N>'
    " NeoBundle "gmarik/snipmate.vim"
  " "}}}
  
  " Git "{{{
    NeoBundle "tpope/vim-fugitive"
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
    NeoBundle "int3/vim-extradite"
      " :Extradite
    NeoBundle "mattn/gist-vim.git"
      " :Gist -p
  " "}}}

  " Ruby "{{{
    " NeoBundle "astashov/vim-ruby-debugger"
      " :RDebugger
    NeoBundle "tpope/vim-endwise"
      " automatic "end" addition
    NeoBundle "tpope/vim-rails"
      " :Rscript...
  " "}}}
  
  " Go-Lang "{{{
    NeoBundle "jnwhiteh/vim-golang"
  " "}}}

  " JavaScript "{{{
    NeoBundle "vim-scripts/jQuery"

    NeoBundle "lukaszb/vim-web-indent"
      let g:js_indent_log = 0

    NeoBundle "kchmck/vim-coffee-script.git"
  " "}}}

  " LaTeX "{{{
    NeoBundle "vim-scripts/LaTeX-Box"
      autocmd FileType tex inoremap <buffer> [[ \begin{
      autocmd FileType tex imap <buffer> ]] <Plug>LatexCloseCurEnv
      autocmd FileType tex vmap <buffer> <Leader>lw <Plug>LatexWrapSelection
      autocmd FileType tex vmap <buffer> <Leader>lW <Plug>LatexEnvWrapSelection
      let g:LatexBox_completion_close_braces = 1
      let g:tex_flavor='latex'
  " "}}}
  
  " HTML "{{{
    NeoBundle "tpope/vim-markdown"
    NeoBundle "tpope/vim-haml"
    NeoBundle "tpope/vim-ragtag"
    NeoBundle "rstacruz/sparkup", {'rtp': 'vim/'}
    NeoBundle 'gregsexton/MatchTag'
  " "}}}

  " Database "{{{
    NeoBundle "vim-scripts/dbext.vim"
      " :h dbext-tutorial
  " "}}}

  " LilyPond "{{{
    NeoBundle "qrps/lilypond-vim"
  " "}}}

  " Tools "{{{
    NeoBundle "vim-scripts/Conque-Shell"
      " :ConqueTerm
    NeoBundle "vim-scripts/renamer.vim"
      " :Renamer
    NeoBundle "mileszs/ack.vim"
      " :Ack [opts] pattern [dir]
    NeoBundle "Shebang"
      nnoremap <leader>X :w<CR>:call SetExecutable()<CR>
    NeoBundle "chrisbra/Recover.vim"
  " "}}}
  
  " Various "{{{
    NeoBundle "amadanmath/amadan.vim"
  " "}}}

  " OS X "{{{
    NeoBundle "sjl/vitality.vim"
      " make vim behave with iTerm2 and tmux
  " }}}

  " Installation check "{{{
    NeoBundleCheck
  " }}}
" "}}}

" Filetype "{{{
  filetype plugin indent on
  syntax on
" "}}}
