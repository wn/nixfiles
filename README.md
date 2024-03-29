# nixfiles

## Nix home-manager setup

Configure personal settings in `home.nix`

### Linux

```bash
curl -L https://nixos.org/nix/install | sh # run as non-root
export NIX_PATH=~/.nix-defexpr/channels
nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh
```

### MacOS

```bash
# From https://gist.github.com/mandrean/65108e0898629e20afe1002d8bf4f223
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
# reboot machine before continuing
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
bash
nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh
```
