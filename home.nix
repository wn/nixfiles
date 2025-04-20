# https://home-manager-options.extranix.com/
{ pkgs, config, lib, ... }:
let
in {
  imports = [ ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

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

      # perf
      ocamlPackages.magic-trace
      hwloc
      linuxPackages.perf
      flamegraph
      gbenchmark

      bash
      bazel
      cmake
      llvm
      coreutils
      curl
      emacs
      delta
      eza
      glib
      nodejs_23
      fzf
      gcc
      gnumake
      nasm
      pyright
      clang-tools
      gnupg
      go
      go-tools
      htop
      hugo
      imagemagick
      jq
      nixfmt
      ripgrep
      R
      texlive.combined.scheme-full
      tmux
      wget

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
      emacs-all-the-icons-fonts

      librsvg
      libtool

      # zsh
      zsh-nix-shell
      zsh-syntax-highlighting
      pure-prompt
    ];
  };

  programs.git = {
    enable = true;
    userName = "Ang Wei Neng";
    userEmail = "weineng.a@gmail.com";
    ignores = [
      "*.DS_Store"
      "*.log"
      "*.sql"
      "*.sqlite"
      ".clangd"
      ".gitmodules"
      ".projectile"
      ".testlist"
      ".tspkg"
      "compile_commands.json"
      "flycheck_"
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
      la = "eza -la";
      gst = "git status";
      gaa = "git add .";
      gcmsg = "git commit -s -m";
      gp = "git push";
      gd = "git diff";
      gl = "git log";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh'';
      rrc = "nix-env --delete-generations old && nix-store --gc";

      doom = "~/.emacs.d/bin/doom";

      # Force g++ compiler to show all warnings and use C++20
      gpp = "g++ -Wall -Weffc++ -std=c++2b -Wextra -Wsign-conversion";
    };

    initExtra = ''
      source /home/weineng/.nix-profile/etc/profile.d/nix.sh
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

  programs.fzf = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = "set -g prefix C-t";
  };

  # Make scripts available at ~/.config/scripts
  home.sessionPath = [
    "${config.home.homeDirectory}/.config/scripts"
  ];

  home.file.".config/scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
