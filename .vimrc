if has('win32')
    lan en
else
    lan en_US.UTF-8
endif

set nocompatible
set backspace=indent,eol,start
set tabstop=4
set shiftwidth=4
set expandtab

call plug#begin()
Plug 'rakuhsg/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'editorconfig/editorconfig-vim'
Plug 'prabirshrestha/vim-lsp'

Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-ui-pum'
Plug 'Shougo/ddc-ui-native'
Plug 'Shougo/ddc-source-around'
Plug 'shun/ddc-source-vim-lsp'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'

Plug 'tani/ddc-fuzzy'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-colortemplate'
Plug 'wuelnerdotexe/vim-astro'
Plug 'lifepillar/vim-colortemplate'
Plug 'dense-analysis/ale'
Plug 'rhysd/vim-lsp-ale'
Plug 'rakuhsg/vim-darkgreen'
Plug 'github/copilot.vim'
Plug 'DanBradbury/copilot-chat.vim'

" better quickfix behavior
Plug 'yssl/QFEnter'
call plug#end()

" Enabling syntax highlighting with Markdown code blocks
let g:markdown_fenced_languages = ['rust', 'rs=rust']

" editorconfig
let g:EditorConfig_preserve_formatoptions = 1

call ddc#custom#patch_global('ui','pum')
" call ddc#custom#patch_global('ui','native')
call ddc#custom#patch_global('sources', [
 \ 'around',
 \ 'vim-lsp',
 \ ])
call ddc#custom#patch_global('sourceOptions', {
 \ '_': {
 \   'matchers': ['matcher_fuzzy'],
 \   'sorters': ['sorter_fuzzy'],
 \   'converters': ['converter_fuzzy'],
 \ },
 \ 'around': {'mark': 'Around'},
 \ 'vim-lsp': {
 \   'mark': 'lsp',
 \   'matchers': ['matcher_head'],
 \   'forceCompletionPattern': '\.|:|->|"\w+/*'
 \ },
 \ 'file': {
 \   'mark': 'file',
 \   'isVolatile': v:true,
 \   'forceCompletionPattern': '\S/\S*'
 \ }})
call ddc#enable()

inoremap <C-j>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-k>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-l>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-h>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
nnoremap <C-w>q :bd<CR>
nnoremap <C-w>? :buffers<CR>

call pum#set_option('preview', v:true)
call pum#set_option('highlight_matches', 'PmenuMatch')

set laststatus=2
set statusline="%f"
syntax enable
filetype plugin indent on
set splitright
"" Editing
""" Hide current mode text on command area.
set number
set belloff=all
"" line breaks
set ff=unix
"" set clipboard=unnamedplus
"" vim-astro
let g:astro_typescript = 'enable'
"" Custom terminal shortcut

if has('win32')
    let g:term_shell = "powershell"
else
    let g:term_shell = "fish"
endif

nnoremap <C-q>w :execute 'vert term ++close ++cols=50 ' . g:term_shell<CR>
nnoremap <silent> <C-l> :FloatermNew --title=lazygit lazygit<CR>
nnoremap <silent> <Tab> :Lf<CR>
nnoremap <silent> <S-Tab> :FZF<CR>
"nnoremap <silent> <C-q>p :call popup_create(term_start(g:term_shell, #{ hidden: 1, term_finish: 'close'}),
    \ #{
    \ border: [], minwidth: float2nr(winwidth(0)*0.75), minheight: float2nr(&lines * 0.75),
    \ maxwidth: float2nr(winwidth(0)*0.75), maxheight: float2nr(&lines * 0.75),
    \ })<CR>
nnoremap <silent> <C-q>p :execute 'FloatermNew --autoclose=1 --title=' . g:term_shell . ' ' . g:term_shell <CR>


"" ALE
nnoremap <silent> ? <plug>(ale_detail)
nnoremap <silent> <leader>f :ALEFixSuggest<CR>
let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \}
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1

let g:ale_set_highlights = 0

let g:ale_fixers = {
    \ 'typescript': ['eslint', 'prettier'],
    \ 'typescriptreact': ['eslint', 'prettier'],
    \ }
let g:ale_linters = {
    \ 'typescript': ['eslint'],
    \ 'typescriptreact': ['eslint'],
    \ 'rust': ['analyzer'],
    \ }
let g:ale_floating_preview = 1
" QuickFix
let g:qfenter_keymap = {}
" Open an item under cursor in the quickfix window.
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
" Open an item under cursor in a new vertical split of the previously focused window.
let g:qfenter_keymap.vopen = ['<leader><leader>']
" Open an item under cursor in a new horizontal split from the previously focused window.
let g:qfenter_keymap.hopen = ['<leader><CR>']
" Open an item under cursor in a new tab.
let g:qfenter_keymap.topen = ['<leader><Tab>']
"" vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    nnoremap <silent> <buffer> <leader>r <plug>(lsp-references)
    nnoremap <silent> <buffer> <leader>s <plug>(lsp-rename)
    nnoremap <silent> <buffer> <leader>d <plug>(lsp-peek-definition)
    nnoremap <silent> <buffer> <leader>gd <plug>(lsp-definition)
    nnoremap <silent> <buffer> <leader>i <plug>(lsp-implementation)
    nnoremap <silent> <buffer> <leader><leader> <plug>(lsp-hover)
    nnoremap <silent> <buffer> <leader>j <plug>(lsp-peek-declaration)
    nnoremap <silent> <buffer> <leader>gj <plug>(lsp-declaration)
    nnoremap <silent> <buffer> <leader>? <plug>(lsp-document-symbol-search)
    nnoremap <buffer> <expr><C-j> lsp#scroll(+4)
    nnoremap <buffer> <expr><C-k> lsp#scroll(-4)
    nnoremap <buffer> <leader> :echom 'r: find references, s: rename, d: peek definition, i: implementation, j: peek declaration, gd: go to definition, gj: go to declaration, ?: symbol search, C-j: scroll down, C-k: scroll up'<CR>

    let g:lsp_format_sync_timeout = 1000
    let g:lsp_diagnostics_enabled = 0
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

""" Register ccls C++ lanuage server.
if executable('ccls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ccls',
        \ 'cmd': {server_info->['ccls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
        \ 'initialization_options': {'cache': {'directory': expand('~/.cache/ccls') }},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc', 'h', 'hh', 'hpp'],
        \ })
""" clangd
elseif executable('clangd')
    au User lsp_setup call lsp#register_server({
         \   'name': 'clangd',
         \   'cmd': {server_info->['clangd', '--enable-config']},
         \   'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc', 'h', 'hh', 'hpp'],
         \ })
endif

""" rust-analyzer
if executable('rust-analyzer')
    au User lsp_setup call lsp#register_server({
        \   'name': 'Rust Language Server',
        \   'cmd': {server_info->['rust-analyzer']},
        \   'whitelist': ['rust'],
        \ })
endif

""" gleam
if executable('gleam')
    au User lsp_setup call lsp#register_server({
        \   'name': 'gleam',
        \   'cmd': {server_info->['gleam', 'lsp']},
        \   'whitelist': ['gleam'],
        \ })
endif

""" typescript-language-server
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'javascript support using typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact']
      \ })
endif

""" pyright
if executable('pyright')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyright-langserver',
        \ 'cmd': { server_info->[&shell, &shellcmdflag, 'pyright-langserver --stdio']},
        \ 'whitelist': ['python']
        \})
endif

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"" custom commands
function! RunCmd()
  call inputsave()
  let name = input('raku@vim $ ')
  call inputrestore()
  execute 'FloatermNew --autoclose=0 --title=Run ' . name
  "call popup_create(term_start(name, #{ hidden: 1 }),
    \ #{
    \ border: [], minwidth: float2nr(winwidth(0)*0.75), minheight: float2nr(&lines * 0.75),
    \ maxwidth: float2nr(winwidth(0)*0.75), maxheight: float2nr(&lines * 0.75),
    \ })
endfunction

nnoremap <silent> <C-x> :call RunCmd()<CR>


" clipboard
command! YankToClipboard call system('wl-copy', getreg('"'))
nnoremap <silent> <C-c> :call system('wl-copy', getreg('"'))<CR>

set termguicolors
colorscheme darkgreen
