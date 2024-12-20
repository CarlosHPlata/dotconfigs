" Pluggins {{{
call plug#begin()

" themes
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'EdenEast/nightfox.nvim'

" Nerd Tree pluggins
" Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vwxyutarooo/nerdtree-devicons-syntax'

" Easy move with leader s
Plug 'easymotion/vim-easymotion'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'preservim/nerdcommenter'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git pluggin
Plug 'tpope/vim-fugitive'

" ctrl p like vscode
Plug 'ctrlpvim/ctrlp.vim'

" find in directory
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" eslint
Plug 'dense-analysis/ale'

Plug 'vim-test/vim-test'

" for navigation between vim and tmux
Plug 'christoomey/vim-tmux-navigator'
call plug#end()
" }}}

"configuracion de nvim {{{

set number
set cursorline
set mouse=a
set numberwidth=1
set clipboard+=unnamedplus
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif


syntax enable
set showcmd
set encoding=utf-8
set expandtab
set ts=2
set sw=2
set relativenumber
" set foldmethod=marker
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

let mapleader=","


" let g:ctrlp_user_command = ['./git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" nerdTree config {{{
" let g:loaded_nerdtree_git_status = 1
let g:NERDTreeGitStatusEnabled = 1
let g:NERDTreeGitStatusShowClean = 1 " default: 0
let g:NERDTreeShowHidden=1
let g:NERDTreeWinSize=50

let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeGitStatusPorcelainVersion = 1
" }}}

" }}}

" nvim theme config{{{
" let g:gruvbox_contrast_dark='hard'
" let g:airline_powerline_fonts = 1
" colorscheme gruvbox
" colorscheme onehalfdark 
" let g:airline_theme='onehalfdark'
colorscheme nightfox
"hi Normal guibg=NONE ctermbg=NONE
" }}}

" mappings {{{

" pluggin mappings {{{
nmap <Leader>s <Plug>(easymotion-s2)

nmap <Leader>nt :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1

nnoremap <leader><Esc> <C-o>:bd term<TAB><CR>
" }}}

" auto closing string tags {{{ 
inoremap ' ''<Esc>i
inoremap " ""<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
" }}}

" auto ident {{{ 
inoremap <leader>> <Esc>>>A
inoremap <leader>< <Esc><<A
nnoremap <leader>o o<Esc>

" }}}

" auto close tag {{{
inoremap <leader>ct </<Esc>2F<lyiwf/pa><Esc>F<i
inoremap <leader>cst </<Esc>2F<lyiwf/pa><Esc>F<i<CR><CR><Esc>kS
" }}}

" add semicolon to end of line w/o losing location {{{ 
inoremap <leader>; <Esc>mlA;<Esc>`la
nnoremap <leader>; mlA;<esc>`l

inoremap <leader><leader> <Esc>mlA,<Esc>`la
nnoremap <leader>, mlA,<Esc>`l

nnoremap <leader>f :CocSearch
nnoremap <leader>F :Files<cr>
nnoremap <leader>tv :botright vnew <Bar> :terminal<cr>
nnoremap <leader>th :botright new <Bar> :terminal<cr>

nnoremap <leader>tt :tabn<cr>
nnoremap <leader>rr :tabp<cr>

" Terminal exit maping
:tnoremap <Esc> <C-\><C-n>

" }}}

" Edit and source inti.vim {{{

" edit init.vim
 nnoremap <leader>ve :e $MYVIMRC<cr>
" source init.vim
 nnoremap <leader>vs :so $MYVIMRC<cr>
" }}}

" javascript and typescript mappings {{{
inoremap <leader>=; ()<Esc>hmmla => {};<Esc>hha<CR><Esc>`ma
inoremap <leader>=> ()<Esc>hmmla => {}<Esc>ha<Esc>`ma
inoremap <leader>-> ()<Esc>hmmla => <Esc>`ma

" inoremap <leader>=; ()<Esc>hmmla => {};<Esc>hha<CR><CR><Esc>`ma
" inoremap <leader>=> ()<Esc>hmmla => {}<Esc>ha<CR><CR><Esc>`ma

inoremap <leader>its it('');<Esc>hhhmmla, () => {<CR>}<Esc>`ma
inoremap <leader>ita it('');<Esc>hhhmmla, async () => {<CR>}<Esc>`ma
inoremap <leader>dsc describe('');<Esc>hhhmmla, () => {<CR>}<Esc>`ma
inoremap <leader>bef beforeEach(() => {});<Esc>hhi<CR><Esc>kA<CR>
inoremap <leader>bea beforeEach( async () => {});<Esc>hhi<CR><Esc>kA<CR>
" }}}

" }}}

" COC Configuration {{{
" =============================== COC CONFIGURATION =====================
" set gui colorscheme

hi! CocErrorSign guifg=#d1666a
" hi! CocErrorSign guifg=#521d01
hi! CocWarningSign guifg=#521d01
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

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
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_ack_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

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
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" =============================== COC CONFIGURATION =====================
" }}}

" treesitter configs {{{

lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF


" }}}


" eslint ale configs {{{

let g:ale_fixers = {
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint']
    \ }

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

" }}}

