{ config, pkgs, ... }: {
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "user";
  home.homeDirectory = "/home/user";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    dhcp
    nixfmt
    git
    fzf
    file
  ];

  programs.git = {
    enable = true;
    userName = "Sean Heath";
    userEmail = "se@nheath.com";
    extraConfig = {
      pull.rebase = false;
    };
  };

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
    '';
  };

  # BASH
  programs.bash = {
    enable = true;
    initExtra = ''
            bind 'set show-all-if-ambiguous on'
            bind 'TAB:menu-complete'
            bind 'set menu-complete-display-prefix on'

            export XZ_DEFAULTS='-T0 -9'
            export EDITOR=nvim
            alias nr="sudo nixos-rebuild switch --flake /etc/nixos"
            alias ns="nix search nixpkgs"
            alias he="nvim /etc/nixos/users/$USER/home.nix && git -C /etc/nixos add ."
              
            direnvinit() {
              if [ ! -e ./.envrc ]; then
                echo "use nix" > .envrc
                direnv allow
              fi
              if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
                cat > default.nix <<'EOF'
      with import <nixpkgs> {};
      mkShell {
        nativeBuildInputs = [
          bashInteractive
        ];
      }
      EOF
              fi
            }



            # Set PATH
            export PATH=$HOME/go/bin:$PATH

            # Set up FZF
            if command -v fzf-share >/dev/null; then
              source "$(fzf-share)/key-bindings.bash"
              source "$(fzf-share)/completion.bash"
            fi

            # Prompt
            BLACK='\e[0;30m'        # Black
            RED='\e[0;31m'          # Red
            GREEN='\e[0;32m'        # Green
            YELLOW='\e[0;33m'       # Yellow
            BLUE='\e[0;34m'         # Blue
            PURPLE='\e[0;35m'       # Purple
            CYAN='\e[0;36m'         # Cyan
            WHITE='\e[0;37m'        # White

            # get current status of git repo
            function nonzero_return() {
                    RETVAL=$?
                    [ $RETVAL -ne 0 ] && echo " $RED[$RETVAL] "
            }

            # get current branch in git repo
            function parse_git_branch() {
                    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
                    if [ ! "$BRANCH" == "" ]
                    then
                            STAT=`parse_git_dirty`
                            echo -e " [$BRANCH$STAT]"
                    else
                            echo ""
                    fi
            }

            # get current status of git repo
            function parse_git_dirty {
                    status=`git status 2>&1 | tee`
                    dirty=`echo -n "$status" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
                    untracked=`echo -n "$status" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
                    ahead=`echo -n "$status" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
                    newfile=`echo -n "$status" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
                    renamed=`echo -n "$status" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
                    deleted=`echo -n "$status" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
                    bits=""
                    if [ "$renamed" == "0" ]; then
                            bits=">$bits"
                    fi
                    if [ "$ahead" == "0" ]; then
                            bits="*$bits"
                    fi
                    if [ "$newfile" == "0" ]; then
                            bits="+$bits"
                    fi
                    if [ "$untracked" == "0" ]; then
                            bits="?$bits"
                    fi
                    if [ "$deleted" == "0" ]; then
                            bits="x$bits"
                    fi
                    if [ "$dirty" == "0" ]; then
                            bits="!$bits"
                    fi
                    if [ ! "$bits" == "" ]; then
                            echo -e " \001$RED\002$bits\001$PURPLE\002"
                    else
                            echo ""
                    fi
            }

            export PS1="\n\[$GREEN\]\u\[$RED\]|\[$WHITE\]\h\[$RED\]|\[$GREEN\]\w\[$PURPLE\]\$(parse_git_branch)\[$RED\]\$(nonzero_return)\[$WHITE\]> "

            # Direnv
            eval "$(direnv hook bash)"
          '';
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
