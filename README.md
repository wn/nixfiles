# Setup MacOS

## Contains

- .vimrc
- .zshrc
  - Install zsh
  - Install powerline
  - Install powerline fonts
  - Install rbenv
  - Install zsh-syntax-highlighting
- .tmux.conf
- authorized_keys
  - Macbook Pro
- scripts
  - forgit (fzf support for git)
- gitconfig
- config: stores .ssh file (~/.ssh/config)

## Apps to download

- [Notion](https://www.notion.so/desktop)
- [Alfred](https://www.alfredapp.com/help/v3/)
  - add hotkey
    - chrome (cmd-shift-c)
    - iterm (cmd-shift-g)
    - Add email snippet (!em)$$
    - Disable spotlight shortcut
    - set appropriate hotkeys for clipboard (cmd-shift-v)
    - Hide menu icon
- dash
- [discord](https://discord.com/api/download?platform=osx)
- [fantastical 2](https://flexibits.com/fantastical/download)
  - Sync email
  - remove icon from menu
- [flux](https://justgetflux.com/)
- [iterm](https://iterm2.com/downloads.html)
- [karabina](https://karabiner-elements.pqrs.org/)
  - Add `karabiner.json` to `~/.config/karabiner`
  - Set backspace, backslash, capslock shortcut
  - Ensure that Apple Internal keyboard is the only set device under `Devices`
- [magnet](https://apps.apple.com/us/app/magnet/id441258766?mt=12)
- [logi option](https://www.logitech.com/en-sg/product/options)
- [qmk toolkit](https://github.com/qmk/qmk_toolbox/releases)
- excel, powerpoint, word
- [send to kindle](https://www.amazon.com/gp/sendtokindle/mac)
- [skype](https://www.skype.com/en/get-skype/)
- [spotify](https://www.spotify.com/us/download/mac/)
- [tidal](https://offer.tidal.com/download?lang=en)
- [spark](https://sparkmailapp.com/download)
- [todoist](https://todoist.com/downloads/mac)
  - Hide menu icon
- [zoom](https://apps.apple.com/us/app/id546505307)
- telegram
  - Download from App store
  - Hide icon in stetings
- [vscode](https://code.visualstudio.com/download)
  - Add path to terminal (ctrl-h -> Add PATH)
- [whatsapp](https://www.whatsapp.com/download/?lang=en)

## Other setups

- [Set up github](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-gpg-key)
  - Create personal access token (github -> settings -> Developer -> access token)
  - Change signing token in gitconfig
- Set keyboard speed in settings
- Set dock
  - Finder, fantastical 2, notion, todoist, chrome, iterm, spark, telegram
  - Application, downloads, bin
- Add bluetooth to menu bar
- Set finder to show developer and home directory in favourites
- Force disable default Apple shit through terminal
  - accent after holding an alphabet `defaults write -g ApplePressAndHoldEnabled -bool false`
