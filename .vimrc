"" Change the interface language (Windows only)
if has('win32')
    lan en
else
    lan en_US.UTF-8
endif

""" Set indent behivor with overwritable by editorconfig-vim.
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

Plug 'lifepillar/vim-colortemplate'
Plug 'wuelnerdotexe/vim-astro'
Plug 'lifepillar/vim-colortemplate'
Plug 'dense-analysis/ale'
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

set splitright
"" Editing
""" Hide current mode text on command area.
colorscheme slate
set number
set belloff=all
"" line breaks
set ff=unix
"" set clipboard=unnamedplus
"" vim-astro
let g:astro_typescript = 'enable'
"" Custom terminal shortcut

if has('win32')
    let shell = "powershell"
    nnoremap <C-q> :vert term ++close ++cols=50 powershell<CR>
else
    let shell = "zsh"
    nnoremap <C-q> :vert term ++close ++cols=50 zsh<CR>
endif

nnoremap <silent> <C-l> :FloatermNew --title=lg lazygit<CR>
nnoremap <silent> <Tab> :Lf<CR>
nnoremap <silent> <C-n> :call popup_create(term_start(shell, #{ hidden: 1, term_finish: 'close'}), #{ border: [], minwidth: float2nr(winwidth(0)*0.75), minheight: float2nr(&lines*0.75) })<CR>

"" ALE
nnoremap <silent> ? <plug>(ale_detail)
nnoremap <silent> <Space>f :ALEFixSuggest<CR>
let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \}
let g:ale_fix_on_save = 1

"" vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    nnoremap <silent> <buffer> <Space>d <plug>(lsp-peek-definition)
    nnoremap <silent> <buffer> <Space>gd <plug>(lsp-definition)
    nnoremap <silent> <buffer> <Space>i <plug>(lsp-implementation)
    nnoremap <silent> <buffer> <Space><Space> <plug>(lsp-hover)
    nnoremap <silent> <buffer> <Space>j <plug>(lsp-peek-declaration)
    nnoremap <silent> <buffer> <Space>gj <plug>(lsp-declaration)
    nnoremap <silent> <buffer> <Space>? <plug>(lsp-document-symbol-search)
    nnoremap <buffer> <expr><C-j> lsp#scroll(+4)
    nnoremap <buffer> <expr><C-k> lsp#scroll(-4)

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

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


"" custom commands
nnoremap <silent> <C-S-x> :term ./x<CR>

hi Pmenu        ctermfg=147 ctermbg=0 cterm=NONE
hi PmenuSel     ctermfg=85 ctermbg=239 cterm=NONE
hi PmenuMatch   ctermfg=99 ctermbg=NONE cterm=NONE
hi LineNr       ctermfg=60 ctermbg=NONE cterm=NONE
