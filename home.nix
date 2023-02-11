{ pkgs, config, lib, ... }:
let
in {
  imports = [ ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  #services.emacs = {
  #  enable = true;
  #  defaultEditor = true;
  #};

  home = {
    username = "weineng";
    homeDirectory = "/Users/weineng";
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
      ]))

      nodePackages.pyright
      nodePackages.mathjax

      bash
      ccls
      hwloc
      coreutils
      curl
      emacs28NativeComp
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
      gopkgs
      gopls
      htop
      hugo
      hyperfine
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
      sqlite
      texlive.combined.scheme-full
      tmux
      wget
      zsh
      libGL

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

      # fonts
      iosevka
      jetbrains-mono
      libre-baskerville
      roboto
      roboto-mono

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
      ".test-all.v1.sqlite3"
      ".testlist"
      "compile_commands.json"
      "compile_commands.zsh"
      ".tspkg"
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
      sl = "exa";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";

      # git aliases
      gm = "git-meta";
      gco = "gm checkout";
      gst = "gm status";
      gcmsg = "gm commit -m";
      gcb = "gm checkout -b";
      gaa = "gm add $(gm root)";
      ga = "gm add";
      gcm = "gm checkout master";
      gca = "gm commit --amend";
      gd = "gm diff";
      gaaa = "gaa && gm commit --amend --no-edit && gm push -f && tsdev pr update";
      gp = "gm push -f && tsdev pr update";
      gpsup = "gm push && tsdev pr create --jira";
      gl = "gm log --decorate --graph";
      gdc = "gm diff --cached";
      gb = "gm branch";
      gpu = "gm pull --rebase upstream master";
      gba = "gm branch -a";
      cdr = "cd $(gm root)";
      grhh = "gm reset --hard";

      # nix-os alias
      rr = ''
        nix-shell -p home-manager --run "home-manager -f ~/nixfiles/home.nix switch" && exec zsh'';
      rrc = "nix-env --delete-generations old && nix-store --gc";

      em = "emacs &";
      e = "emacs -nw";
      doom = "~/.emacs.d/bin/doom";

      # Force g++ compiler to show all warnings and use C++20
      gpp = "g++ -Wall - Weffc ++ -std=c++20 -Wextra -Wsign-conversion";
    };

    localVariables = {
      EDITOR = "emacs -nw";
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

      function pyenv() {
        echo "Starting pyenv: $1"
        python3 -m venv $1 && source $1/bin/activate
      }

      # check that PATH don't contain dir before prepending.
      function pathadd() {
        if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
          PATH="''${PATH:+"$PATH:"}$1"
        fi
      }

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
        echo "Emacs not installed yet"
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
        git clone https://github.com/wn/doom.d ~/.doom.d
        ~/.emacs.d/bin/doom install
      fi

      # from http://www.catern.com/pipes.html
      # pad to the maximize size we can do and still be atomic on this system
      pipe_buf=$(getconf PIPE_BUF /)
      function pad() {
          # redirect stderr (file descriptor 2) to /dev/null to get rid of noise
          dd conv=block cbs=$pipe_buf obs=$pipe_buf 2>/dev/null
      }
      function unpad() {
          dd conv=unblock cbs=$pipe_buf ibs=$pipe_buf 2>/dev/null
      }

      function flame() {
          perf record -g --call-graph fp -- g++
          perf script | stackcollapse-perf.pl > out.perf-folded;
          flamegraph.pl out.perf-folded > perf.svg;
          rm out.perf-folded perf.data;
      }
    '';
  };

  programs.home-manager = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shortcut = "u";
  };

#   # Scripts
#   home.file.".config/scripts".source = ./files/scripts;
#   home.file.".config/scripts".recursive = true;
#   home.sessionPath = ["$HOME/.config/scripts" "$HOME/dotfiles/.bin"];
}
