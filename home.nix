{ pkgs, config, lib, ... }:

let
  inherit (lib) mkMerge;
  git_userName = "Ang Wei Neng";
  git_userEmail = "weineng.a@gmail.com";
  git_signing_key = "1C3A31CF1EB43ABC1766DB2F1C8D1EA6010A15FC";
in {
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;
  fonts.fontconfig.enable = true;
  # home.file.".doom.d".source = ./doom.d;
  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "20.09";
    packages = with pkgs; [
      ripgrep
      jq
      zsh
      fzf
      # exa
      # vscode
      emacs
      htop
      # nixfmt
      curl
      wget
      hub
      gnupg
      pinentry
      bash
      mosh
      tmux
      go
      go-tools
      go-outline
      gopls
      gopkgs
      nmap
    ];
  };

  imports = [  ];

  programs.git = {
    enable = true;
    userName = git_userName;
    userEmail = git_userEmail;
    iniContent = {
      commit.gpgSign = git_signing_key != "";
      signing.key = git_signing_key;
    };
    ignores =
      [ "*.log" "*.DS_Store" "*.sql" "*.sqlite" "*.DS_Store*" "*.idea" ];
    aliases = {
      st = "status";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core = {
        autocrlf = false;
        editor = "vim";
      };

      pull.rebase = true;
      init.defaultBranch = "main";
      status = { submodulesummary = true; };
      gpg = { program = "gpg"; };
    };
  };

  programs.zsh = {
    # https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = false;

    shellAliases = {
      ls = "ls";
      sl = "ls";
      l = "ls -l";
      la = "ls -la";

      # git aliases
      git = "git";
      gco = "git checkout";
      gst = "git status";
      gcmsg = "git commit -m";
      gcb = "git checkout -b";
      gaa = "git add .";
      ga = "git add";
      gcm = "git checkout master";
      gca = "git commit --amend --no-edit";
      gd = "git diff";
      gaaa = "gaa && gca && gp";
      gl = "git log";
      glg = "git log --all --decorate --oneline --graph";
      gdc = "git diff --cached";
      gp = "git push";

      # nix-os alias
      reset = ''
        nix-shell -p home-manager --run "home-manager -f ~/.dotconfig/home.nix switch" && exec zsh'';

      # Force g++ compiler to show all warnings and use C++11
      gpp = "g++ -Wall - Weffc ++ -std=c++11 -Wextra -Wsign-conversion";
    };

    localVariables = { EDITOR = "vim"; };

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

    envExtra = ''
      if [[ $OSTYPE == 'darwin'* ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH
        eval "$(/usr/local/bin/brew shellenv)";
      fi
    '';

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

      # set up pure
      autoload -U promptinit
      promptinit
      prompt pure

      export PATH="$PATH:$HOME/.emacs.d/bin"

      zstyle :prompt:pure:git:stash show yes
    '';
  };

  programs.home-manager = { enable = true; };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Scripts
  # home.file.".config/zsh/scripts".source = ./files/scripts;
  # home.file.".config/zsh/scripts".recursive = true;
}
