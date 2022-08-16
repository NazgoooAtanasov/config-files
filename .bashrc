#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach

source /usr/share/git/completion/git-completion.bash
source /usr/share/git/completion/git-prompt.sh

# PS1='[\u@\h \W]\$ '
_BLUE=$(tput setaf 4)
_GREEN=$(tput setaf 2)
_RED=$(tput setaf 1)
_RESET=$(tput sgr0)
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
PS1='[${_BLUE}\u@\h${_RESET} ${_GREEN}\W${_RESET} ${_RED}$(__git_ps1 "git (%s)")${_RESET}]\$ '

PATH=$PATH:/home/nazgo/.dotnet/tools:/home/nazgo/go/bin
PATH=$PATH:/home/nazgo/.emacs.d/bin
PATH=$PATH:/home/ng/.cargo/bin

EDITOR="nvim"
TERM=xterm-256color

alias update="sudo pacman -Syu"
alias search="pacman -Ss"
alias install="sudo pacman -S"
alias remove="sudo pacman -Rcns"
alias installed="pacman -Q | less"
alias nve="v ~/config-files/nvim/init.lua"

alias ai="GIT_SSH_COMMAND='ssh -i /home/nazgo/.ssh/acne'"

alias ls="exa -la"
alias v="nvim"

# Git aliasses
# alias 'git r'="git rebase -i"
alias githardreset="git fetch && git reset --hard @{u}"

alias personal="GIT_SSH_COMMAND='ssh -i /home/nazgo/.ssh/personal'"

alias tmuxd="tmux detach"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ ${BLE_VERSION-} ]] && ble-attach
