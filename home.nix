{ pkgs, config, lib, ... }: {
  home.username = "weineng";
  home.homeDirectory = "/Users/weineng";
  home.stateVersion = "20.09";
  # home.sessionPath = [ "/opt/ts/bin" ];

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  imports = [ ./packages.nix ];

  programs.git = {
    enable = true;
    userName = "Weineng Ang";
    userEmail = "weineng.a@gmail.com";
    ignores = [ "*.log" "*.DS_Store" "*.sql" "*.sqlite" "*.DS_Store*" "*.idea" ];
    iniContent = {
      commit.gpgSign = true;
      signing.key = "1C8D1EA6010A15FC";
    };
    aliases = {
      st = "status";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core = {
        autocrlf = false;
        editor = "nano";
      };

      pull.rebase = true;
      init.defaultBranch = "main";
      status = {
        submodulesummary = true;
      };
    };
  };

  programs.zsh = {
    # https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = false;
    enableCompletion = true;

    shellAliases = {
      sl = "exa";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";
      gm = "git";
      gco = "gm checkout";
      gst = "gm status";
      gcmsg = "gm commit -m";
      gcb = "gm checkout -b";
      gaa = "gm add .";
      ga = "gm add";
      gcm = "gm checkout master";
      gca = "gm commit --amend --no-edit";
      gd = "gm diff";
      gaaa = "gaa && gca && gp";
      install = "gssproxy2 fixedout";
      gl = "gm log";
      reset = "nixpkgs-fmt ~/.dotconfig/home.nix && nix-shell -p home-manager --run \"home-manager -f ~/.dotconfig/home.nix switch\" && exec zsh";
      # Force g++ compiler to show all warnings and use C++11
      gpp = "g ++ -Wall - Weffc ++ -std=c++11 -Wextra -Wsign-conversion";
      glg = "git log --all --decorate --oneline --graph";
      gdc = "git diff --cached";
    };

    localVariables = {
      EDITOR = "vim";
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

    envExtra = ''
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
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

      zstyle :prompt:pure:git:stash show yes
    '';
  };

  programs.home-manager = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Scripts
  # home.file.".config/zsh/scripts".source = ./files/scripts;
  # home.file.".config/zsh/scripts".recursive = true;
}
