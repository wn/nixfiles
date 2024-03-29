{ pkgs, config, lib, ... }:
let
in {
  nixpkgs.overlays = [
    (self: super: {
      fcitx-engines = pkgs.fcitx5;
    })
  ];
  imports = [ ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  services.emacs = {
     enable = true;
     defaultEditor = true;
  };

  home = {
    username = "weineng";
    homeDirectory = "/home/weineng";
    stateVersion = "20.09";
    packages = with pkgs; [
      (python39.withPackages (p: with p; [
        isort
        matplotlib
        nose
        numpy
        pyflakes
        pygments
        pytest
        pylint
        flask
        compiledb
      ]))

      nodePackages.pyright
      nodePackages.mathjax

      emacsPackages.compat

      bazel
      bash
      ccls
      coreutils
      curl
      nodejs_20
      emacs29
      delta
      exa
      fd
      fzf
      flamegraph
      clang
      clang-tools
      git
      gnupg
      go
      go-outline
      go-tools
      docker
      docker-compose
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
      pinentry
      pipenv
      ripgrep
      R
      rstudio
      sqlite
      texlive.combined.scheme-full
      tmux
      wget
      zsh
      libGL
      pass
      gotty

      # pdfviewer for emacs
      emacsPackages.pdf-tools
      cairo
      libpng
      poppler

      # rust
      cargo
      cargo-edit
      clippy
      rust-analyzer
      rustc
      ninja

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
    userName = "Wei Neng Ang";
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
      ".test-all.v1.sqlite3"
      ".testlist"
      ".tspkg"
      "compile_commands.json"
      "compile_commands.zsh"
      "flycheck_*"
      "CMakeFiles"
      "*.cmake"
      "CMakeCache.txt"
      "build.ninja"
    ];
    aliases = {
      st = "status";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core ={
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
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;

    shellAliases = {
      ls = "exa";
      l = "exa -l";
      la = "exa -la";

      # git aliases
      gm = "git";
      gco = "gm checkout";
      gst = "gm status";
      gcmsg = "gm commit -S -m";
      gcb = "gm checkout -b";
      gaa = "gm add $(gm root)";
      ga = "gm add";
      gcm = "gm checkout master";
      gca = "gm commit --amend";
      gd = "gm diff";
      gaaa = "gaa && gm commit --amend --no-edit && gm push -f";
      gp = "gm push";
      gpsup = "gm push";
      gl = "gm log --decorate --graph";
      gdc = "gm diff --cached";
      gb = "gm branch";
      gpu = "gm pull --rebase upstream master";
      gba = "gm branch -a";
      cdr = "builtin cd $(gm root)";
      grhh = "gm reset --hard";
      gss = "gm submodule status";
      goc = "gm open -c $(gm rev-parse HEAD)";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh'';
      rrc = "nix-env --delete-generations old && nix-store --gc";

      em = "emacs -nw";
      e = "emacs -nw";
      doom = "~/.emacs.d/bin/doom";

      # Force g++ compiler to show all warnings and use C++20
      gpp = "g++ -Wall -Weffc++ -std=c++2a -Wextra -Wsign-conversion";

      # two sigma specific alias
      # braindump = "builtin cd ~/.org/braindump && make";
      # bump = "cdr && builtin cd ts/mmia/bump/";
      # mra = "make realclean all";
      # mara = "make-all realclean all";
      # t = "./bin/tstest";
      # tsi = "cdr && builtin cd ts/tss/integration";
      # tt = "tsdev test";
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
      # {
      #   name = "formarks";
      #   src = fetchFromGitHub {
      #     owner = "wfxr";
      #     repo = "formarks";
      #     rev = "8abce138218a8e6acd3c8ad2dd52550198625944";
      #     sha256 = "1wr4ypv2b6a2w9qsia29mb36xf98zjzhp3bq4ix6r3cmra3xij90";
      #   };
      #   file = "formarks.plugin.zsh";
      # }
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

      # two sigma specific stuff
      if [[ $(hostname -d) = *twosigma.com ]]; then
         source /nix/setup-nix.sh
         export TZ='America/New_York';
         export no_proxy="twosigma.com,*.twosigma.com,127.0.0.1,localhost";

         pathadd "$HOME/.config/scripts"
         pathadd "$HOME/dotfiles/.bin"
         pathadd "$HOME/.local/sdkconfig"

         # install packages blocked by 2s
         # hack: use nixGL to determine whether to install packages
         if [ $(dpkg-query -W -f='$\{Status\}' nixGL 2>/dev/null | grep -c "ok installed") -ne 0 ]; then
             gssproxy2 -e nix-env --file https://github.com/catern/nix-utils/archive/master.tar.gz --install
             gssproxy2 nix-env --file https://github.com/guibou/nixGL/archive/main.tar.gz -iA auto.nixGLDefault
         fi
      fi

      function flame() {
          perf record -g --call-graph fp -- g++
          perf script | stackcollapse-perf.pl > out.perf-folded;
          flamegraph.pl out.perf-folded > perf.svg;
          rm out.perf-folded perf.data;
      }

      # xclip issue causing ERROR: target STRING not available: https://github.com/astrand/xclip/issues/38
      if [ ! -z "$DISPLAY" ] ; then
          echo "$DISPLAY" > "$HOME/.most-recent-display"
      elif [ -r "$HOME/.most-recent-display" ] ; then
          export DISPLAY=$(cat "$HOME/.most-recent-display")
      fi
    '';
  };

  programs.home-manager = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    #enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = "set -g prefix C-t";
  };

  # Scripts
  home.file.".config/scripts".source = ./files/scripts;
  home.file.".config/scripts".recursive = true;
  home.sessionPath = ["$HOME/.config/scripts" "$HOME/dotfiles/.bin"];
}
