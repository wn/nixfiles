#! /bin/zsh

EXCLUDE=('README.md', 'install.sh')

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
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh > /dev/null 2>&1

echo '[+] Deployment complete'
