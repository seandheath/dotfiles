{ config, pkgs, ... }: {
  # VIM
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-toml
      vim-nix
      nerdtree
      rainbow_parentheses
      rust-vim
      deoplete-go
      deoplete-rust
      zig-vim
      SudoEdit-vim
    ];
    extraConfig = ''
filetype plugin indent on

set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set clipboard+=unnamedplus

let mapleader = ","

" NERDTREE
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" DEOPLETE
let g:deoplete#enable_at_startup = 1
    '';
  };
}
