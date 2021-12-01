
# Set up nix-config directory 
echo "Setting up configuration directory"
CONFDIR=$HOME/.config/nix-config
GEN=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}')
unlink $CONFDIR
ln -s $(pwd) $CONFDIR

# Add channels
echo "Adding channels"
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager
nix-channel --update

# Set up home-manager
echo "Installing home-manager"
nix-shell '<home-manager>' -A install
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
rm $HOME/.config/nixpkgs/home.nix
ln -s $CONFDIR/home.nix $HOME/.config/nixpkgs/home.nix

# Set up system config file
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-$GEN.nix.bak
sudo --preserve-env=CONFDIR ln -s $CONFDIR/$HOSTNAME.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch --upgrade
home-manager switch
