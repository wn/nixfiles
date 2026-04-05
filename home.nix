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

      #jumk
      nodejs
      docker

      ### fedora packages
      # ulauncher # add super-space to ulaucher-toggle in custom shortcuts
      wmctrl
      uv
      gpaste
      spotify
      sqlite
      wl-clipboard

      # nodePackages.mathjax
      claude-code
      hyperfine     
      wireshark
      cpuid
      flamegraph
      gbenchmark
      hwloc
      perf
      sysstat
      ocamlPackages.magic-trace
      pprof
      perf_data_converter # for pprof


      opam
      dune

      # nice to have in terminals
      R
      bash
      bazel
      bear
      # clang
      clang-tools
      cmake
      # codex
      coreutils
      curl
      delta
      emacs
      eza
      fd
      gcc
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
      rr
      texlive.combined.scheme-full
      wget
      pandoc
      strace
      ltrace
      numactl
      valgrind
      pure-prompt
      zsh
      zsh-nix-shell

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
      # NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
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
      ".cache/"
      ".vscode/"
      "CMakeFiles/"
      "*.code-workspace"
      "*.log"
      "*.sql"
      "*.sqlite"
      ".DS_Store"
      ".base_universe"
      ".builderrors"
      ".gitmodules"
      ".projectile"
      "CMakeCache.txt"
      "build.ninja"
      "cmake_install.cmake"
      "compile_commands.json"
      "flycheck_*"
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
      nixr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch"'';
      nixrc = "nix-env --delete-generations old && nix-store --gc";
      genflame = "perf script | stackcollapse-perf.pl | flamegraph.pl > /tmp/flamegraph.svg && google-chrome /tmp/flamegraph.svg";

      doom = "~/.emacs.d/bin/doom";

      # Force c++ compiler to show all warnings and use C++20
      gpp = "c++ -Wall -Weffc++ -std=c++2b -Wextra -Wsign-conversion";
    };

    plugins = with pkgs; [ ];

    initContent = ''
      autoload -U promptinit; promptinit
      prompt pure

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      setopt MENU_COMPLETE
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./config/tmux/tmux.conf.extra);
  };

  home.sessionPath = [
    "${config.xdg.configHome}/scripts"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  systemd.user.services.kmonad = {
    Unit = {
      Description = "KMonad Keyboard Daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.kmonad}/bin/kmonad ${config.xdg.configHome}/files/kmonad.kbd";
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

  xdg.configFile."clangd/config.yaml".text =
    builtins.replaceStrings
      [ "@C++COMPILER@" ]
      [ "${pkgs.gcc}/bin/g++" ]
      (builtins.readFile ./config/clangd/config.yaml.in);

  xdg.configFile."gdb/gdbinit".text = ''
    ${(builtins.readFile ./config/gdb/gdbinit.in)}
    set libthread-db-search-path ${pkgs.glibc}/lib
   '';

  home.file.".clang-format".text = ''
    BasedOnStyle: google
    IndentWidth: 4
    TabWidth: 4
    UseTab: Never
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
