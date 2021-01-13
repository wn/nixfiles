DEFAULT_USER=$USER
export TERM="xterm-256color"
set mouse=a
HYPHEN_INSENSITIVE="true"

# PATH config
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH=$PATH:/usr/local/go/bin

# Aliases
alias tmuxk="tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill"
alias lsf='ssh weineng@sunfire.comp.nus.edu.sg'
alias dev='cd ~/Developer'
alias doc='cd ~/Documents'
alias cwd='pwd | pbcopy && echo $(pwd)'
alias play='cd ~/playground'
alias dl='cd ~/Downloads'
alias doomsync='sh ~/.emacs.d/bin/doom sync'
alias eject='(){ diskutil eject /Volumes/$1 ;}'
alias reload='source /etc/zprofile && source ~/.zshrc'
# Force g++ compiler to show all warnings and use C++11
alias gpp='g++ -Wall -Weffc++ -std=c++11 -Wextra -Wsign-conversion'

############################## Overriden alias #########################################
alias mv='mv -i'
alias sudo="sudo -E"
alias ls='ls -lhG'

# Override default 'pwd' to escape spaces in path
function pwd() {
  printf "%q\n" "$(builtin pwd)"
}

# Override default 'cd' to show files (ls)
function cd() {
  builtin cd $@ && ls
}

### PYTHON shortcuts ###
function pyenv() {
  echo "Starting pyenv: $1"
  python3 -m venv $1 && source $1/bin/activate
}

############################## ZSH config #########################################
plugins=(
  git
)

### Set up shell and scripts
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit

# set up pure
autoload -U promptinit
promptinit
prompt pure

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"
export GPG_TTY=$(tty)

############################## Git #########################################
# Hub configuration
alias git="hub"
# Alias to replace git plugin
alias gap="git add -p"
alias gdc="git diff --cached"
alias gcmsg="git commit -S -m"
alias glg="git log --all --decorate --oneline --graph"


############################## Homebrew #########################################
export PATH=/opt/homebrew/bin:$PATH
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/etc/profile.d/z.sh

### APPLE SILLICON HACKS ###
# Alias to handle brew for apple m1 chip
alias brewi='/usr/local/homebrew/bin/brew' # for intel
alias brewa='/opt/homebrew/bin/brw' # for arm

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
eval "$(rbenv init -)"

############################## Scripts startup #########################################

# fzf support
# `brew install fzf`
# `bash /usr/local/opt/fzf/install`

# Usage:
# ctrl-r to find history
# ctrl-t to find files in directory
# alt-t to find sub-directories
source ~/.fzf.zsh

# Source all scripts defined in ~/.scripts
for script in ~/.scripts/*; do
  source <(cat "$script")
done

############################## Misc #########################################
export CS107E=~/Developer/cs107e.github.io/cs107e
export PATH=$PATH:$CS107E/bin
alias rpi='~/Developer/cs107e.github.io/cs107e/bin/rpi-install.py'
