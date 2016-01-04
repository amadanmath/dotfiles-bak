" General "{{{
  set nocompatible
  set history=256
  set autowrite
  set clipboard+=unnamed
  set pastetoggle=<f5>
  set tags=./tags;$HOME
  set encoding=utf-8
  set virtualedit=block
  set matchpairs+=<:>
  set cryptmethod=blowfish

  set autoread
  au CursorHold,CursorHoldI * checktime

  if has('unnamedplus')
    set clipboard+=unnamedplus
  else
    set clipboard+=unnamed
  endif

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
  "set textwidth=72
  set wildmode=list:longest,list:full
  set wildmenu

  set backspace=indent,eol,start

  set tabstop=8
  set softtabstop=2
  set shiftwidth=2
  set shiftround
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


  let s:pattern = '^\(.*\):h\([1-9][0-9]*\)$'
  let s:minfontsize = 6
  let s:maxfontsize = 16
  function! AdjustFontSize(amount)
    let fontname = substitute(&guifont, s:pattern, '\1', '')
    let cursize = substitute(&guifont, s:pattern, '\2', '')
    if fontname == ''
      let fontname = 'Monaco'
    endif
    if cursize == ''
      let cursize = '10'
    endif
    let newsize = cursize + a:amount
    if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
      let newfont = fontname . ':h' . newsize
      let &guifont = newfont
    endif
  endfunction

  command! -count=1 LargerFont call AdjustFontSize(<count>)
  command! -count=1 SmallerFont call AdjustFontSize(-<count>)



  " Neat fold text "{{{
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
  autocmd FileType xml,xhtml nnoremap <buffer> <Leader>rx :%!tidy -q -i -utf8 -xml<CR>

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

  " jump to a line and the line of before and after of the same indent. "{{{
  nnoremap <silent> g{ :<C-u>call search('^' .
        \ matchstr(getline(line('.') + 1), '\(\s*\)') .'\S', 'b')<CR>^
  nnoremap <silent> g} :<C-u>call search('^' .
        \ matchstr(getline(line('.')), '\(\s*\)') .'\S')<CR>^
  " "}}}

  " paste without yanking in visual mode with P
  xnoremap <expr> P '"_d"'.v:register.'P'

  " insert into camelcase
  nnoremap <leader>S ~hi

  " toggle wrap
  nnoremap <leader>qw :set wrap!<CR>

  " show/hide foldcolumn with foldenable "{{{
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
  " "}}}

  " Toggle hex edit mode "{{{
  let g:hex_mode_on = 0
  let g:hex_mode_saved_foldenable = &foldenable
  function! ToggleHex()
      if g:hex_mode_on
          execute "%!xxd -r"
          let g:hex_mode_on = 0
          let &foldenable = g:hex_mode_saved_foldenable
      else
          execute "%!xxd"
          let g:hex_mode_on = 1
          let g:hex_mode_saved_foldenable = &foldenable
          set nofoldenable
      endif
  endfunction
  nmap <Leader>rh :call ToggleHex()<CR>
  " "}}}

  " Exchange gj and gk to j and k. "{{{
  command! -nargs=0 -bar ToggleGJK call s:ToggleGJK()
  nnoremap <silent> <Leader>rj :<C-u>ToggleGJK<CR>
  xnoremap <silent> <Leader>rj :<C-u>ToggleGJK<CR>
  function! s:ToggleGJK()
    if exists('b:enable_mapping_gjk') && b:enable_mapping_gjk
      let b:enable_mapping_gjk = 0
      noremap <buffer> j j
      noremap <buffer> k k
      noremap <buffer> gj gj
      noremap <buffer> gk gk

      xnoremap <buffer> j j
      xnoremap <buffer> k k
      xnoremap <buffer> gj gj
      xnoremap <buffer> gk gk
    else
      let b:enable_mapping_gjk = 1
      noremap <buffer> j gj
      noremap <buffer> k gk
      noremap <buffer> gj j
      noremap <buffer> gk k

      xnoremap <buffer> j gj
      xnoremap <buffer> k gk
      xnoremap <buffer> gj j
      xnoremap <buffer> gk k
    endif
  endfunction
  " "}}}
" }}}

  " Search for selected text, forwards or backwards. "{{{
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
  nnoremap <Leader>y p<C-A>==yy

  " edit vimrc
  nnoremap <Leader>rv :e ~/.vimrc<CR>

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
  nnoremap <Leader>rn :call RenameInFile()<CR>

  " buffer delete without closing a window "{{{
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
  " "}}}

  " find merge conflicts
  nnoremap <silent> <Leader>rc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

  " compensate for way too tiny escape key on mac air
  inoremap kj <Esc>
" "}}}

" MacVim specific stuff "{{{
  if has('gui_macvim')
    " set guifont=Monaco:h10
    " set noantialias
    nnoremap <silent> <SwipeLeft> :macaction _cycleWindowsBackwards:<CR>
    nnoremap <silent> <SwipeRight> :macaction _cycleWindows:<CR>
  endif
" "}}}

" VimDiff "{{{
if &diff
  " Ignore whitespace
  set diffopt+=iwhite
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
      if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
        echo "Installing NeoBundle\n"
        silent execute '!mkdir -p ~/.vim/bundle'
        silent execute '!git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim'
      endif
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch "Shougo/neobundle.vim"
  " "}}}

  " Unite "{{{
    NeoBundle "Shougo/vimproc", {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
    NeoBundle "Shougo/unite.vim"
    NeoBundleLazy 'tsukkee/unite-tag', { 'autoload' : {
        \   'unite_sources' : 'tag'
        \ }}

    " Mappings "{{{
      nnoremap <Leader>uu :<C-u>Unite -start-insert file_rec/async<CR>
    " }}}
  " "}}}

  " Appearance "{{{
    NeoBundle "sickill/vim-monokai"

    " LightLine "{{{
    NeoBundle "itchyny/lightline.vim"
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
            \   'left': [ [ 'mode', 'paste' ], [ 'gdifff', 'fugitive', 'filename' ], ['ctrlpmark'] ],
            \   'right': [[ 'lineinfo', 'syntastic' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype']]
            \ },
            \ 'inactive': {
            \   'left': [[ 'gdifff', 'fugitive', 'filename' ], ['ctrlpmark'] ],
            \   'right': [[ 'lineinfo', 'syntastic' ], ['percent']]
            \ },
            \ 'component_function': {
            \   'gdifff': 'MyGdifff',
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

      function! MyGdifff()
        return exists('b:gdifffmode') ? b:gdifffmode : ''
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
      nnoremap <leader>nn :NumbersToggle<CR>
      " gives relative numbers in normal mode
  " "}}}

  " Buffer Navigation "{{{
    NeoBundle "scrooloose/nerdtree"
      let NERDChristmasTree = 1
      let NERDTreeQuitOnOpen = 1
      nnoremap <silent> <F2> :NERDTreeToggle<CR>
      nnoremap <silent> <S-F2> :execute "NERDTree ".expand("%:p:h")<CR>

    NeoBundle "jlanzarotta/bufexplorer"
      nnoremap <F3> :BufExplorerToggle<CR>

    NeoBundle "majutsushi/tagbar"
      nnoremap <script> <silent> <F4> :TagbarToggle<CR>
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

    NeoBundle "kien/ctrlp.vim"
      let g:ctrlp_map = '<Leader>^'
      " (project home)
      let g:ctrlp_working_path_mode = 2
      let g:ctrlp_custom_ignore = {
        \   'dir':  '\.git$\|\.hg$\|\.svn\|data$',
        \   'file': '\.so$',
        \ }
      if executable('ag')
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
      endif
      

    NeoBundle "vim-scripts/ZoomWin"
      " <C-W>o
    
    NeoBundle "Lokaltog/vim-easymotion.git"

    NeoBundle 'justinmk/vim-sneak'
      " s__, S__
  " "}}}

  " Editing "{{{
    NeoBundle "tpope/vim-repeat"
    NeoBundle "vim-scripts/visualrepeat"
    NeoBundle "tpope/vim-abolish"
      " coerce with cr?
    NeoBundle "tpope/vim-unimpaired"
      " [, ] with many many actions
    NeoBundleLazy "edsono/vim-matchit", { 'autoload': {
        \   'mappings' : ['%', 'g%']
        \ }}
      " better % (g%, a%, [%, ]%)
    NeoBundle "kurkale6ka/vim-pairs"
      " better text objects for punct, and "q" for quotes
    NeoBundle "tpope/vim-surround"
      " ys... 
    NeoBundle "tpope/vim-speeddating"
      " enhances <C-A>, <C-X>

    NeoBundle "kana/vim-textobj-user"
      " library for vim-textobj-rubyblock
    NeoBundle "nelstrom/vim-textobj-rubyblock", {
        \   'depends': 'kana/vim-textobj-user',
        \ }
      " r = ruby block (ar, ir)
    NeoBundle "amadanmath/Parameter-Text-Objects"
      " P = parameter (aP, iP)
    NeoBundle "michaeljsmith/vim-indent-object"
      " i = indent (with/out a single line header)
      " I = indent (with/out enclosing indent block)

    NeoBundle "tpope/vim-commentary"
      " gc<motion> comments and toggles, gcu uncomments

    NeoBundle "scrooloose/syntastic"
      " checks syntax on save
    NeoBundle "henrik/vim-indexed-search"
      " shows search index/position (also, g/)
    NeoBundle "vim-scripts/file-line"
      " opening file:line:column works
    NeoBundle "mbbill/undotree"
      nnoremap <F6> :UndotreeToggle<CR>
      nnoremap <S-F6> :UndotreeShow<CR>:UndotreeFocus<CR>
      if has("persistent_undo")
        set undodir="~/.vim/undo"
        set undofile
      endif

    NeoBundle "chreekat/vim-paren-crosshairs"
      " show column of paren as well
    NeoBundle "ConradIrwin/vim-bracketed-paste"
      " turn on paste mode on insert-mode paste
    NeoBundleLazy 'bkad/CamelCaseMotion', { 'autoload' : {
        \   'mappings': '<Plug>CamelCaseMotion_',
        \ }}
      map <silent> <Leader>w <Plug>CamelCaseMotion_w
      map <silent> <Leader>b <Plug>CamelCaseMotion_b
      map <silent> <Leader>e <Plug>CamelCaseMotion_e
      map <silent> <Leader>W <Plug>CamelCaseMotion_w
      map <silent> <Leader>B <Plug>CamelCaseMotion_b
      map <silent> <Leader>E <Plug>CamelCaseMotion_e
      omap <silent> i<Leader>w <Plug>CamelCaseMotion_iw
      xmap <silent> i<Leader>w <Plug>CamelCaseMotion_iw
      omap <silent> i<Leader>b <Plug>CamelCaseMotion_ib
      xmap <silent> i<Leader>b <Plug>CamelCaseMotion_ib
      omap <silent> i<Leader>e <Plug>CamelCaseMotion_ie
      xmap <silent> i<Leader>e <Plug>CamelCaseMotion_ie

    NeoBundle 'PeterRincker/vim-argumentative'
      " , operator for moving ([,), text object (i,) amd shifting (<,) params

    NeoBundle 'junegunn/vim-easy-align'
  " "}}}
  
  " Completion "{{{
    if has('lua')
      NeoBundle "Shougo/neocomplete.vim"
        let g:neocomplete_enable_at_startup = 1
    else
      NeoBundle "Shougo/neocomplcache.vim"
        let g:neocomplcache_enable_at_startup = 1
    endif

    " NeoBundleLazy 'teramako/jscomplete-vim', { 'autoload' : {
    "     \   'filetypes' : 'javascript'
    "     \ }}
  " "}}}
  
  " Git "{{{
    NeoBundle "tpope/vim-fugitive"
      " :Git ...
      autocmd BufReadPost fugitive://* set bufhidden=delete
      function! Gdifff()
        nnoremap <buffer> dk :diffget //1<CR>:diffupdate<CR>
        nnoremap <buffer> dh :diffget //2<CR>:diffupdate<CR>
        nnoremap <buffer> dl :diffget //3<CR>:diffupdate<CR>
        nnoremap <buffer> dj :diffupdate<CR>
        Gdiff :1
        Gdiff :2
        Gdiff :3
        1wincmd w
        let b:gdifffmode='Parent'
        4wincmd w
        let b:gdifffmode='Other'
        3wincmd w
        let b:gdifffmode='Merge'
        2wincmd w
        let b:gdifffmode='Current'
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
  
  " Swift "{{{
    NeoBundle "toyamarinyon/vim-swift"
  " "}}}

  " Go-Lang "{{{
    NeoBundle "jnwhiteh/vim-golang"
  " "}}}

  " JavaScript "{{{
    NeoBundleLazy 'jelera/vim-javascript-syntax', { 'autoload': {
        \   'filetypes': ['javascript']
        \ }}
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
    NeoBundle "slim-template/vim-slim.git"
    NeoBundle "tpope/vim-ragtag"
    NeoBundle "rstacruz/sparkup", {'rtp': 'vim/'}
    NeoBundle 'gregsexton/MatchTag'
    NeoBundle 'hail2u/vim-css3-syntax'
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
    if executable('ack')
      NeoBundle "mileszs/ack.vim", { 'autoload' : { 'commands' : ['Ack'] } }
        " :Ack [opts] pattern [dir]
    endif
    if executable('ag')
      NeoBundleLazy "rking/ag.vim", { 'autoload' : { 'commands' : ['Ag'] } }
      " :Ag [opts] pattern [dir]
    endif
    NeoBundle "Shebang"
      nnoremap <Leader>rx :w<CR>:call SetExecutable()<CR>
    NeoBundle "chrisbra/Recover.vim"
    NeoBundleLazy "FredKSchott/CoVim", { 'autoload': { 'commands': ['CoVim'], } }
      let CoVim_default_name = "Amadan"
      let CoVim_default_port = "3636"  
    NeoBundleLazy 'vim-scripts/Conque-Shell', { 'autoload' : {
        \ 'commands' : 'ConqueTerm'
        \ }}
  " "}}}
  
  " Documentation "{{{
    NeoBundle 'rizzatti/funcoo.vim'
    NeoBundleLazy 'rizzatti/dash.vim', {
        \ 'autoload': {
        \   'commands': [ 'Dash', 'Dash!', 'DashKeywords', 'DashSettings' ],
        \   'mappings': [ '<Plug>DashSearch', '<Plug>DashGlobalSearch' ],
        \ }}
      nmap <silent> <Leader>da <Plug>DashSearch
      nmap <silent> <Leader>dd <Plug>DashGlobalSearch
  " "}}}
  
  " Various "{{{
    NeoBundle "amadanmath/amadan.vim"
  " "}}}

  " OS X "{{{
    NeoBundle "sjl/vitality.vim"
      " make vim behave with iTerm2 and tmux
  " }}}

" "}}}


" Local vimrc if exists " {{{
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
" " }}}

" End of bundles " {{{
 call neobundle#end()
" " }}}


" Filetype "{{{
  filetype plugin indent on
  syntax on
" "}}}

" Plugin Installation check "{{{
  NeoBundleCheck
" }}}

  colorscheme monokai

" TODO Configure NeoComplCache and Unite, maybe install Notational Velocity (nvim)"
