" =========================
" init.vim
" =========================

" Ensure runtimepath includes local config folders
set runtimepath^=~/.config/nvim

" Load all modular configs
for f in split(glob('~/.config/nvim/configs/*.vim'), '\n')
  exe 'source' f
endfor

" Optional: load custom colorscheme
colorscheme molokai256

" Optional: Load Lua entry point if exists (future-proof)
if filereadable(expand('~/.config/nvim/lua/init_lua.lua'))
  lua require('init_lua')
endif
