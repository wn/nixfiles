#! /bin/zsh

EXCLUDE=('README.md', 'install.sh', 'iterm', 'vimium_dvorak.txt', 'authorized_keys', 'config')

if ! command -v zsh &> /dev/null
then
    echo '[+] Installing zsh'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

for config in *
do
    if [[ ${EXCLUDE[*]} =~ $config ]]
    then
        :
    else
        if [ -e ~/.${config} ]
        then
            echo "[-] Dotfile ~/.${config} already exists. Skipping..."
        else
            echo "[+] Creating symlink: ~/.${config}"
            ln -s ${PWD}/${config} ~/.${config}
        fi
    fi
done

echo '[+] Dotfiles have been deployed'

echo '[+] Fetching & Installing dependencies'
# curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh > /dev/null 2>&1

if ! command -v brew &> /dev/null
then
    echo '[+] Installing brew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install zsh-syntax-highlighting zsh-autosuggestions z hub fzf
fi

echo '[+] Deployment complete'

source ~/.zshrc