{ pkgs, config, lib, ... }: {
  home.username = "weineng";
  home.homeDirectory = "/Users/weineng";
  home.stateVersion = "20.09";
  programs.git.iniContent = {
    commit.gpgSign = true;
    signing.key = "1C3A31CF1EB43ABC1766DB2F1C8D1EA6010A15FC";
  };
  programs.git.userName = "Ang Wei Neng";
  programs.git.userEmail = "weineng.a@gmail.com";

  # home.sessionPath = [ "/opt/ts/bin" ];

  program.zsh.envExtra = ''
    if [[ $OSTYPE == 'darwin'* ]]; then
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH
      eval "$(/usr/local/bin/brew shellenv)";
    fi
  '';
}
