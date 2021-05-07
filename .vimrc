let mapleader = " "

" Ensure spelling in code files
syntax spell toplevel

set list
set listchars=tab:>-,extends:›,precedes:‹,nbsp:·,trail:·

" Default spelling language
" set spell spelllang=en_us
" syntax on

" GUI SETTINGS
set number
set clipboard=unnamedplus
" tabs
set softtabstop=0
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
"searching
set hlsearch
set ignorecase
set incsearch
set smartcase

set encoding=utf-8
set laststatus=2
set wildmenu

set cursorline
set nowrap
set noswapfile


" For different cursors in normal / insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
"
" Initialize gruvbox
let g:gruvbox_guisp_fallback = "bg"
autocmd vimenter * colorscheme gruvbox

" For gruvbox dark theme
set background=dark

" optional reset cursor on start:
augroup autoCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Status line configuration
" ------------------------------------
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! GitPWD()
    
   let l:dir=system("git rev-parse --show-toplevel 2>/dev/null | tr -d '\n'")
    
  return 
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#Search#
set statusline+=%{StatusDiagnostic()}
set statusline+=%#CursorColumn#
set statusline+=\ %p%%
set statusline+=\ %y
set statusline+=\ %l:%c
set statusline+=\ 
" File paths with space is ok
set isfname+=32

" insert task
nmap tno o[ ] 
nmap tni I[ ] <ESC> A
nmap td F[<ESC><Right>rx<ESC>$
nmap tu F[<ESC><Right>r <ESC>$

nmap <leader>n1 :e ~/notes/log<CR>
nmap <leader>n0 :e ~/.vimrc<CR>

" autocmd BufEnter * silent! lcd %:p:h
" autocmd BufWinEnter * silent :let b:localpwd=system('git rev-parse --show-toplevel 2>/dev/null || pwd')
" autocmd BufWinEnter * silent :exe "lcd " . b:localpwd

nmap <leader>r :CocCommand cSpell.toggleEnableSpellChecker<CR>

" copy current file path
nmap cp :let @+=expand("%:p") . ':' . line(".") . "\n" <CR>
nmap gf gF

" save
nmap zs :w<CR>
set nocompatible              " be improved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" For toggle between tmux panes without C-b
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'morhetz/gruvbox'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'neoclide/jsonc.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'zivyangll/git-blame.vim'

" For file search with FZF
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'
call vundle#end()

filetype plugin indent on

" CoC Default configuration
" ------------------------------------
"
" TextEdit might fail if hidden is not set.
set hidden

" Extensions
let g:coc_global_extensions = ['coc-css', 'coc-eslint', 'coc-json', 'coc-tsserver', 'coc-yaml', 'coc-prettier']

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" Use `gp` and `gn` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" clear hl on esc
nnoremap <esc> :noh<return><esc>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  :CocCommand eslint.executeAutofix<CR>
nmap <leader>.  :CocCommand prettier.formatFile<CR>
" <Plug>(coc-fix-current)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')


" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


" Fzf mappings
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" create dirpath when editing new file
au BufNewFile * :exe ': !mkdir -p ' . escape(fnamemodify(bufname('%'),':p:h'),'#% \\')

:nmap <leader>p :Files<CR>
:nmap <leader>P :ProjectFiles<CR>
:nmap <leader>f :Rg<CR>
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
:nnoremap <Leader>o <C-w>S
:nnoremap <Leader>i <C-w>v
:nnoremap <Leader>x :q<CR>


:autocmd BufRead,BufNewFile ~/dev/stampen/mina-sidor-backend/* setlocal autoindent noexpandtab tabstop=4 shiftwidth=4
:autocmd BufRead,BufNewFile ~/dev/stampen/mina-sidor-frontend/* setlocal autoindent noexpandtab tabstop=4 shiftwidth=4

autocmd BufRead,BufNewFile *.json set filetype=jsonc
