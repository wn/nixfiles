{ pkgs, config, lib, ... }:
let
in {
  imports = [ ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home = {
    username = "weineng";
    homeDirectory = "/Users/weineng";
    stateVersion = "20.09";
    packages = with pkgs; [
      (python3.withPackages (p: with p; [
        matplotlib
        numpy
        pyflakes
        pyright
        pygments
        pytest
        pylint
        flask
      ]))

      nodePackages.mathjax

      emacsPackages.compat
      emacsPackages.pdf-tools

      bash
      bazel
      cmake
      llvm
      coreutils
      curl
      emacs29
      delta
      eza
      glib
      gbenchmark
      fd
      fzf
      flamegraph
      gcc
      qemu
      nasm
      git
      clang-tools
      gnupg
      go
      go-outline
      go-tools
      gopkgs
      gopls
      htop
      hugo
      imagemagick
      jq
      llvm
      mosh
      mplayer
      nixfmt
      nmap
      pipenv
      ripgrep
      R
      sqlite
      texlive.combined.scheme-full
      tmux
      wget
      zsh
      libGL

      # pdfviewer for emacs
      cairo
      libpng
      poppler

      # rust
      cargo
      cargo-edit
      clippy
      rust-analyzer
      rustc

      # fonts
      iosevka
      jetbrains-mono
      libre-baskerville
      roboto
      roboto-mono
      source-code-pro

      librsvg
    ];
  };

  programs.git = {
    enable = true;
    userName = "Ang Wei Neng";
    userEmail = "weineng.a@gmail.com";
    ignores = [
      "*.DS_Store"
      "*.DS_Store*"
      "*.code-workspace"
      "*.log"
      "*.sql"
      "*.sqlite"
      "*.vscode"
      ".ccls-cache"
      ".clangd"
      ".gitmodules"
      ".projectile"
      ".testlist"
      ".tspkg"
      "compile_commands.json"
      "flycheck_*"
    ];
    aliases = {
      st = "status";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core = {
        autocrlf = false;
        editor = "emacs -nw -Q -f menu-bar-mode";
      };
      pull.rebase = true;
      http.emptyauth = true;
      init.defaultBranch = "main";
      status = { submodulesummary = true; };
      diff = {
        submodule = "diff";
      };
      gpg = {
        program = "gpg";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza";
      l = "eza -l";
      la = "eza -la";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh'';
      rrc = "nix-env --delete-generations old && nix-store --gc";

      em = "emacsclient -c -n &";
      e = "emacsclient -c -n";
      doom = "~/.emacs.d/bin/doom";

      # Force g++ compiler to show all warnings and use C++20
      gpp = "g++ -Wall -Weffc++ -std=c++2a -Wextra -Wsign-conversion";
    };

    plugins = with pkgs; [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "pure";
        src = fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "1.20.1";
          sha256 = "1bxg5i3a0dm5ifj67ari684p89bcr1kjjh6d5gm46yxyiz9f5qla";
        };
        file = "pure.zsh";
      }
    ];

    initExtra = ''
      function pwd() {
        printf "%q\n" "$(builtin pwd)"
      }

      # Override default 'cd' to show files (ls)
      function cd() {
        builtin cd $@ && ls
      }

      # check that PATH don't contain dir before prepending.
      function pathadd() {
        if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
          PATH="''${PATH:+"$PATH:"}$1"
        fi
      }

      export TERM=xterm-256color
      export TERMCAP=

      # set up pure
      autoload -U promptinit
      promptinit
      prompt pure
      zstyle :prompt:pure:git:stash show yes

      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      setopt MENU_COMPLETE

      if [[ $OSTYPE == 'darwin'* ]]; then
         source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
         export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH
         eval "$(/usr/local/bin/brew shellenv)";
      fi

      if [[ ! -d "$HOME/.emacs.d/" ]]; then
        echo "doom emacs not installed yet"
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
        git clone https://github.com/wn/doom.d ~/.doom.d
        ~/.emacs.d/bin/doom install
      fi

      function flame() {
          perf record -g --call-graph fp -- g++
          perf script | stackcollapse-perf.pl > out.perf-folded;
          flamegraph.pl out.perf-folded > perf.svg;
          rm out.perf-folded perf.data;
      }
    '';
  };

  programs.home-manager = {
    enable = false;
  };

  programs.fzf = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = "set -g prefix C-t";
  };

  # Scripts
  # home.file.".config/scripts".source = ./files/scripts;
  # home.file.".config/scripts".recursive = true;
  # home.sessionPath = ["$HOME/.config/scripts" "$HOME/dotfiles/.bin"];
}
