"Plugins {{{
    call plug#begin()

    "Git integration
    Plug 'tpope/vim-fugitive'

    "Autocompletion
    function! DoRemote(arg)
        UpdateRemotePlugins
    endfunction
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    "Language protocol support
    Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh'
    \ }

    "Fuzzy file finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    "Additional syntax detection & highlighting
    Plug 'rust-lang/rust.vim'

    "See editorconfig.org
    Plug 'editorconfig/editorconfig-vim'

    "Sneaky motions
    Plug 'justinmk/vim-sneak'

    "Better JS highlighting & indentation
    Plug 'pangloss/vim-javascript'

    "TypeScript syntax highlighting
    Plug 'leafgarland/typescript-vim'

    "TypeScript completion support
    Plug 'Quramy/tsuquyomi'

    "Syntax checking
    Plug 'w0rp/ale'

    "Async execution for vim (dependency of tsuquyomi)
    Plug 'Shougo/vimproc.vim', { 'do': 'make' }

    "JSX support
    Plug 'mxw/vim-jsx'

    "CoffeeScript support
    Plug 'kchmck/vim-coffee-script'

    "Haxe support
    Plug 'rf-/vaxe'

    "Improved Markdown support
    Plug 'plasticboy/vim-markdown'

    "ActionScript support
    Plug 'jeroenbourgois/vim-actionscript'

    "Modify surrounding chars, such as parantheses & quotes
    Plug 'tpope/vim-surround'

    "NERDTree
    Plug 'scrooloose/nerdtree'

    "Vim sugar for the UNIX shell commands
    Plug 'tpope/vim-eunuch'

    "Vim bindings for rtags, llvm/clang based c++ code indexer
    Plug 'lyuts/rtags'

    "Theme airlines
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'morhetz/gruvbox'

    "OmiSharp
    Plug 'OmniSharp/omnisharp-vim'

    "Buff tab lines
    Plug 'ap/vim-buftabline'

    call plug#end()

"}}}
