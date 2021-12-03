{ config, pkgs, ... }: {
  # VIM
  home.packages = with pkgs; [
    pandoc
    texlive.combined.scheme-small
  ];
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
      deoplete-nvim
      deoplete-go
      deoplete-rust
      zig-vim
      SudoEdit-vim
      vim-pandoc
      vim-pandoc-syntax
      markdown-preview-nvim
    ];
    extraConfig = ''
filetype plugin indent on

set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set clipboard+=unnamedplus

let mapleader = ","

" PANDOC
nnoremap <leader>v :MarkdownPreview<CR>
nnoremap <leader>pd :Pandoc docx<CR>
nnoremap <leader>pp :Pandoc pdf<CR>
let g:pandoc#syntax#conceal#urls = 1

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
