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
        flask
        matplotlib
        numpy
        pip
        pyflakes
        pygments
        pylint
        pytest
        requests
        rpm
        ruff
      ]))

      # keyboard macro helper
      kmonad

      ### fedora packages
      # ulauncher # add super-space to ulaucher-toggle in custom shortcuts
      wmctrl
      gpaste
      spotify
      sqlite

      nodePackages.mathjax

      # perf
      cpuid
      flamegraph
      gbenchmark
      hwloc
      perf
      ocamlPackages.magic-trace

      # nice to have in terminals
      R
      bash
      bazel
      bear
      clang # plays better with clangd and header discovery
      clang-tools
      cmake
      codex
      coreutils
      curl
      delta
      emacs
      eza
      fd
      # gcc # probably should use nix-shell if gcc is necessary
      gdb
      gdbgui
      glib
      gnumake
      go
      go-tools
      htop
      hugo
      imagemagick
      jq
      llvm
      nasm
      nixfmt
      openjdk
      pinentry-all
      pyright
      ripgrep
      texlive.combined.scheme-full
      wget

      # pdfviewer for emacs
      cairo
      emacsPackages.cask
      emacsPackages.pdf-tools
      libpng
      librsvg
      libtool
      pkg-config
      poppler

      # rust
      cargo
      cargo-edit
      clippy
      rust-analyzer
      rustc
      rustfmt

      # fonts
      iosevka
      jetbrains-mono
      libre-baskerville
      roboto
      roboto-mono
      source-code-pro
      emacs-all-the-icons-fonts
    ];

    sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
      NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

  services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1; # 1 second
      pinentry.package = pkgs.pinentry-gnome3;
      extraConfig = ''
        allow-loopback-pinentry
        ignore-cache-for-signing
      '';
  };

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.gpg.enable = true;
  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ang Wei Neng";
        email = "weineng.a@gmail.com";
      };
      alias = {
        root = "rev-parse --show-toplevel";
      };
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
        pinentry-mode = "gnome3";
        use-agent = true;
      };
    };
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
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza";
      la = "eza -la";

      gaa = "git add .";
      gcmsg = "git commit -s -m";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      grhh = "git reset --hard";
      gst = "git status";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch"'';
      rrc = "nix-env --delete-generations old && nix-store --gc";

      doom = "~/.emacs.d/bin/doom";

      # Force c++ compiler to show all warnings and use C++20
      gpp = "c++ -Wall -Weffc++ -std=c++2b -Wextra -Wsign-conversion";
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
     ];

    initContent = ''
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

      # autoload -Uz compinit && compinit
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
    "${config.xdg.configHome}/scripts"
  ];

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

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    comment = "Emacs Editor";
    exec = "emacs";
    icon = "emacs";
    terminal = false;
    categories = [ "Development" "TextEditor" ];
  };

  xdg.configFile."clangd/config.yaml".text = ''
    CompileFlags:
      Compiler:"${pkgs.clang}/bin/clang++"
      Add: [-std=c++23]
  '';

  xdg.configFile."gdb/gdbinit".text = ''
    # ---- Debuginfod: make it permanent (no interactive prompt) ----
    set debuginfod enabled on

    # Optional: keep Fedora’s server (you can add more URLs if you use others)
    set debuginfod urls https://debuginfod.fedoraproject.org/

    # ---- Safe auto-loading (pretty-printers, helpers) ----
    # Allow auto-loaded scripts from Nix store without opening the entire filesystem.
    add-auto-load-safe-path /nix/store
    set auto-load safe-path /nix/store:$debugdir:$datadir/auto-load

    # (Optional) If you still see thread debugging warnings, Nix GDB usually helps.
    # You can also guide GDB to libthread_db from Nix glibc:
    set libthread-db-search-path ${pkgs.glibc}/lib
  '';

  # Make scripts available at ~/.config/scripts
  xdg.configFile."scripts" = {
    source = ./scripts;
    recursive = true;
  };

  xdg.configFile."files/" = {
    source = ./files;
    recursive = true;
  };
}
