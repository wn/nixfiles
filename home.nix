# https://home-manager-options.extranix.com/
{ pkgs, config, lib, ... }:
let
in {
  imports = [ ];

  home = {
    username = "weineng";
    homeDirectory = "/home/weineng";
    stateVersion = "20.09";
    packages = with pkgs; [
      (python3.withPackages (p: with p; [
        matplotlib
        numpy
        pyflakes
        pygments
        pytest
        pylint
        flask
        rpm
      ]))

      nodePackages.mathjax

      jetbrains-mono

      kmonad

      # perf
      ocamlPackages.magic-trace
      hwloc
      linuxPackages.perf
      flamegraph
      gbenchmark

      R
      bash
      bazel
      clang-tools
      cmake
      coreutils
      curl
      delta
      emacs
      eza
      fzf
      gcc
      glib
      gnumake
      gnupg
      go
      go-tools
      htop
      hugo
      imagemagick
      jq
      llvm
      nasm
      nixfmt
      ocaml
      openjdk
      pyright
      pinentry-all
      ripgrep
      texlive.combined.scheme-full
      tmux
      wget

      # pdfviewer for emacs
      cairo
      libpng
      librsvg
      libtool
      emacsPackages.pdf-tools
      emacsPackages.cask
      poppler
      glib
      pkg-config

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
      emacs-all-the-icons-fonts
      ocamlPackages.ocaml-lsp
      ocamlPackages.odoc
      ocamlPackages.ocamlformat
      ocamlPackages.utop
    ];

    sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
      NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

  services.gpg-agent = {
      enable=true;
      defaultCacheTtl = 60; #1min
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-all}/bin/pinentry-curses
        allow-loopback-pinentry
      '';
  };

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.gpg.enable = true;
  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    userName = "Ang Wei Neng";
    userEmail = "weineng.a@gmail.com";
    ignores = [
      ".DS_Store"
      "*.code-workspace"
      "*.log"
      "*.sql"
      "*.sqlite"
      "*.vscode"
      ".gitmodules"
      ".projectile"
      ".test-all.v1.sqlite3"
      "compile_commands.json"
      "flycheck_*"
      "CMakeFiles"
      "CMakeCache.txt"
      "build.ninja"
      ".builderrors"
      ".base_universe"
      "cmake_install.cmake"
      ".cache"
    ];
    aliases = {
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
      commit.gpgSign = true;
      signing.signByDefault = true;
      gpg = {
        program = "${pkgs.gnupg}/bin/gpg";
        pinentry-mode = "loopback";
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
      la = "eza -la";
      gst = "git status";
      gaa = "git add .";
      gcmsg = "git commit -s -m";
      gp = "git push";
      gd = "git diff";
      gl = "git log";
      grhh = "git reset --hard";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh'';
      rrc = "nix-env --delete-generations old && nix-store --gc";

      doom = "~/.emacs.d/bin/doom";

      # Force g++ compiler to show all warnings and use C++20
      gpp = "g++ -Wall -Weffc++ -std=c++2b -Wextra -Wsign-conversion";
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
      export GPG_TTY=$(tty)

      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi

      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi

      # Override default 'cd' to show files (ls)
      function cd() {
        builtin cd $@ && ls
      }

      export TERM=xterm-256color

      # set up pure
      export PURE_PROMPT_DIR="${pkgs.pure-prompt}/share/zsh/site-functions"
      fpath+=($PURE_PROMPT_DIR)
      autoload -U promptinit; promptinit
      prompt pure
      zstyle :prompt:pure:git:stash show yes

      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      setopt MENU_COMPLETE
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
set -g prefix C-t
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
set -g base-index 1
setw -g pane-base-index 1
set-option -g renumber-windows on
set-environment -g COLORTERM "truecolor"
'';
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.config/scripts"
  ];

  # Make scripts available at ~/.config/scripts
  home.file.".config/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  home.file.".config/files/" = {
    source = ./files;
    recursive = true;
  };

  systemd.user.services.kmonad = {
    Unit = {
      Description = "KMonad Keyboard Daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.kmonad}/bin/kmonad ${config.home.homeDirectory}/.config/files/kmonad.kbd";
      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
