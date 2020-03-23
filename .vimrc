" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set encoding=utf-8
scriptencoding utf-8

if (has("gui_running"))
  set guifont=Inconsolata_for_Powerline:h16
  set guioptions -=m "remove menubar
  set guioptions -=T "removes toolbar
  set guioptions -=r "removes right scrollbar
  set visualbell
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if &compatible
  set nocompatible
end

" Remove declared plugins
function! s:UnPlug(plug_name)
  if has_key(g:plugs, a:plug_name)
    call remove(g:plugs, a:plug_name)
  endif
endfunction
command!  -nargs=1 UnPlug call s:UnPlug(<args>)

let g:has_async = v:version >= 800 || has('nvim')

call plug#begin('~/.vim/bundle')

" Define bundles via Github repos
Plug 'tpope/vim-fugitive' " git integration 
Plug 'chriskempson/vim-tomorrow-theme'  " default theme I use
Plug 'airblade/vim-gitgutter' " shows git changes in the gutter
Plug 'tpope/vim-vinegar' " enhancements to netrw integrations
Plug 'ctrlpvim/ctrlp.vim' " fuzzy file search
Plug 'editorconfig/editorconfig-vim' " obeys editorconfig
Plug 'maksimr/vim-jsbeautify' " tools for beautifying js and json
Plug 'rking/ag.vim' " uses the silver searcher for project wide searching
Plug 'vim-scripts/tComment' " toggle comments
Plug 'tpope/vim-dispatch' " async tasks
Plug 'tpope/vim-dotenv'  " .env support
Plug 'tpope/vim-vividchalk' " neat colors
Plug 'vim-airline/vim-airline' " the bottom ui
Plug 'vim-airline/vim-airline-themes' " bottom ui themes
Plug 'tpope/vim-unimpaired' " shortcuts [q ]q
Plug 'christoomey/vim-run-interactive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'godlygeek/tabular'
Plug 'groenewege/vim-less'
Plug 'janko-m/vim-test'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'pbrisbin/vim-mkdir'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'xenoterracide/html.vim'
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-clang-format'
Plug 'andypayne/vim-checkbox'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'vhdirk/vim-cmake'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

if g:has_async
  Plug 'w0rp/ale' " asychronous syntax checker
  Plug 'skywind3000/asyncrun.vim'
endif

call plug#end()

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

set list listchars=tab:»·,trail:·,nbsp:·
set nojoinspaces
filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json

  " ALE linting events
  if g:has_async
    set updatetime=1000
    let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0)
    autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5
set wildmode=list:longest,list:full

" Switch between the last two files
nnoremap <Leader><Leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

nnoremap <Leader>j :redraw!<CR>
set modelines=1
set nowrap
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Netrw
let g:netrw_banner = 0

" Markdown
command! -nargs=* Wrap set wrap linebreak nolist tw=0

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_javascript_checkers = ['eslint']

" Gists
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_get_multiplefile = 1
let g:gist_api_url = 'https://github.com/api/v3'

" Ctrl-P
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store --ignore "**/*.pyc" -g ""'

" Airline
let g:airline_powerline_fonts = 1

" Color Scheme
colorscheme Tomorrow-Night-Eighties
