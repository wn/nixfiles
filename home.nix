{ pkgs, config, lib, ... }:

let
  git_userName = "Ang Wei Neng";
  git_userEmail = "weineng@twosigma.com";
  git_signing_key = "1C3A31CF1EB43ABC1766DB2F1C8D1EA6010A15FC";

  zsh_initExtra = ''
    if [[ $OSTYPE == 'darwin'* ]]; then
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH
      eval "$(/usr/local/bin/brew shellenv)";
    fi

    TZ='America/New_York'; export TZ;
    LC_ALL=en_US.UTF-8
  '';
in {
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;
  home.file.".doom.d".source = ./doom.d;

  # services.emacs = { enable = true; };

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "20.09";
    packages = with pkgs; [
      python3Packages.pylint
      python3Packages.pyflakes
      python3Packages.matplotlib
      python3Packages.numpy
      python3Packages.pygments
      python3Packages.isort
      python3Packages.pytest
      python3Packages.nose

      nodePackages.pyright

      bash
      cmake
      coreutils
      curl
      emacs28NativeComp
      exa
      fd
      fzf
      gnupg
      go
      go-outline
      go-tools
      gopkgs
      gopls
      htop
      hub
      jq
      mosh
      nixfmt
      nmap
      pinentry
      pipenv
      ripgrep
      tmux
      wget
      zsh

      libgccjit
      gcc11

      # pdfviewer for emacs
      libpng12
      zlib
      pkgconfig
      poppler

      # rust specific packages
      rustc
      rust-analyzer
      clippy
      emacs28Packages.rustic
      cargo-edit
      cargo

      # latex
      texlive.combined.scheme-full
      mplayer

      # fonts
      iosevka
      roboto
      roboto-mono
      jetbrains-mono
      iosevka
      libre-baskerville

      hugo

      poppler
      automake
      pkg-config

    ];
  };
  programs.git = {
    enable = true;
    userName = git_userName;
    userEmail = git_userEmail;
    ignores = [
      "*.log"
      "*.DS_Store"
      "*.sql"
      "*.sqlite"
      "*.DS_Store*"
      "*.vscode"
      "*.code-workspace"
      "compile_commands.json"
      ".clangd"
    ];
    aliases = {
      st = "status";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core = { autocrlf = false; };

      pull.rebase = true;
      init.defaultBranch = "main";
      status = { submodulesummary = true; };
      diff = { submodule = "log"; };
      gpg = { program = "gpg"; };
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = false;

    shellAliases = {
      sl = "exa";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";

      # git aliases
      git = "git";
      gm = "git";
      gco = "gm checkout";
      gst = "gm status";
      gcmsg = "gm commit -m";
      gcb = "gm checkout -b";
      gaa = "gm add $(git root)";
      ga = "gm add";
      gcm = "gm checkout master";
      gca = "gm commit --amend";
      gd = "gm diff";
      gaaa =
        "gaa && gm commit --amend --no-edit && gm push -f && tsdev pr update";
      gl = "gm log --decorate --graph";
      gdc = "gm diff --cached";
      gb = "gm branch";
      gpu = "gm pull --rebase upstream master";
      gba = "gm branch -a";
      cdr = "cd $(git root)";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/.dotconfig/home.nix switch" && exec zsh'';

      # emacs alias
      em = "emacs &";
      doom = "~/.emacs.d/bin/doom";
      doomsync = "reset && doom sync";

      # Force g++ compiler to show all warnings and use C++11
      gpp = "g ++ -Wall - Weffc ++ -std=c++11 -Wextra -Wsign-conversion";
    };

    localVariables = { EDITOR = "nano"; };

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
        name = "formarks";
        src = fetchFromGitHub {
          owner = "wfxr";
          repo = "formarks";
          rev = "8abce138218a8e6acd3c8ad2dd52550198625944";
          sha256 = "1wr4ypv2b6a2w9qsia29mb36xf98zjzhp3bq4ix6r3cmra3xij90";
        };
        file = "formarks.plugin.zsh";
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
        name = "zsh-autopair";
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
        file = "autopair.zsh";
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

      # set up pure
      autoload -U promptinit
      promptinit
      prompt pure
      zstyle :prompt:pure:git:stash show yes

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      setopt MENU_COMPLETE
    '' + zsh_initExtra;
  };

  programs.home-manager = { enable = true; };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shortcut = "u";
  };

  # Scripts
  # home.file.".config/zsh/scripts".source = ./files/scripts;
  # home.file.".config/zsh/scripts".recursive = true;
}
