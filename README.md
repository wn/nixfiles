# nixfiles

## Nix home-manager setup

Configure personal settings in `home.nix`

### Linux

```bash
curl -L https://nixos.org/nix/install | sh # run as non-root
export NIX_PATH=~/.nix-defexpr/channels
nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh
```

#### bashrc
``` bash
. /home/weineng/.nix-profile/etc/profile.d/nix.sh
export NIX_PATH=~/.nix-defexpr/channels
zsh

```
#### fedora
``` bash
localectl set-keymap dvorak
sudo dnf install jetbrains-mono-fonts-all iosevka roboto
sudo dnf debuginfo-install kernel # for perf
```
gnome tweaks -> keyboard -> emacs binding

Set up [ssh](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and [gpg](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key) keys for github

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
