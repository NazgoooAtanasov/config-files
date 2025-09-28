ZSH_THEME="awesomepanda"

PATH=$PATH:/home/nazgo/.dotnet/tools:/home/nazgo/go/bin
PATH=$PATH:/home/nazgo/.emacs.d/bin
PATH=$PATH:/home/ng/.cargo/bin
PATH=$PATH:/home/ng/eclipse
PATH=$PATH:/home/ng/_Projects/lsp/target/release
PATH=$PATH:/opt/asdf-vm/bin
PATH=$PATH:/home/ng/bin/depot_tools
PATH=$PATH:/home/ng/bin/Odin
PATH=$PATH:/home/ng/bin/zen
PATH=$PATH:/home/ng/.nimble/bin
PATH=$PATH:/home/ng/.asdf/shims
PATH=$PATH:/home/ng/bin/zig-linux-x86_64-0.14.0

export EDITOR="nvim"
TERM=xterm-256color

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The following lines were added by compinstall
zstyle :compinstall filename '/home/ng/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
bindkey -v
# End of lines configured by zsh-newuser-install


if [[ -z ${ZSH-} ]]; then
  export ZSH="$HOME/.oh-my-zsh"
fi

export JIRA_URL=https://acnestudios.atlassian.net
export JIRA_NAME=Atanas Atanasov
export JIRA_PREFIX=SFRA-
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

alias ls="exa -la"
alias nve="v ~/config-files/nvim/init.lua"
alias v="nvim"
alias ac="cd /home/ng/_Forkpoint/acne/app-project"
alias githardreset="git fetch && git reset --hard @{u}"
alias tmuxd="tmux detach"
alias tmuxks="tmux kill-session"
alias tmux="tmux -u"
alias ch="git branch -a | grep -v \"remotes\" | fzf | xargs git checkout"
alias sd="cd \$(find . -maxdepth 2 -type d -not -path '*/node_modules/*' -not -path '*/.cache/*' -not -path '*/.cargo/*' -not -path '*/.npm/*' -not -path '*/.git/*' -not -path '*/.vscode/*' -not -path '*/.local/*' -not -path '*/.vscode-oss/*' -not -path '*/.swa/*' | fzf)"

# bun completions
[ -s "/home/ng/.bun/_bun" ] && source "/home/ng/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/ng/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Turso
export PATH="$PATH:/home/ng/.turso"

# source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# opencode
export PATH=/home/ng/.opencode/bin:$PATH
