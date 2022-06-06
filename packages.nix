{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    jq
    zsh
    fzf
    exa
    # vscode
    htop
    nixfmt
    curl
    wget
    hub
    mosh
    tmux
    go
    go-tools
    go-outline
    gopls
    gopkgs
    nmap
  ];
}