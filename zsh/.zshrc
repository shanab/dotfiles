# Machine-specific setup that must run first (gitignored)
[[ -f ~/.config/zsh/.zshrc.pre.private ]] && source ~/.config/zsh/.zshrc.pre.private

eval $(/opt/homebrew/bin/brew shellenv)

# Path to your oh-my-zsh installation.
# Reevaluate the prompt string each time it's displaying a prompt
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR=/opt/homebrew/bin/nvim

alias la=tree
alias cat=bat

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# GO
export GOPATH="$HOME/go"

# VIM
alias v="/opt/homebrew/bin/nvim"

# Nmap
alias nm="nmap -sC -sV -oN nmap"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# PATH configuration (consolidated)
export PATH="$HOME/.vimpkg/bin:$GOPATH/bin:$HOME/.cargo/bin:$PATH"

alias cl='clear'

# K8S
export KUBECONFIG=~/.kube/config
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias kl="kubectl logs -f"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'
alias podname=''

# HTTP requests with xh!
alias http="xh"

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# SEC STUFF
alias server='python -m http.server 4445'

### FZF ###
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

alias mat='osascript -e "tell application \"System Events\" to key code 126 using {command down}" && tmux neww "cmatrix"'

function ranger {
	local IFS=$'\t\n'
	local tempfile="$(mktemp -t tmp.XXXXXX)"
	local ranger_cmd=(
		command
		ranger
		--cmd="map Q chain shell echo %d > "$tempfile"; quitall"
	)

	${ranger_cmd[@]} "$@"
	if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
		cd -- "$(cat "$tempfile")" || return
	fi
	command rm -f -- "$tempfile" 2>/dev/null
}
alias rr='ranger'

# navigation
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

export XDG_CONFIG_HOME="$HOME/.config"

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
eval "$(pyenv init - zsh)"

# Read aloud (controls afplay playback)
alias pause-reading='pkill -STOP afplay 2>/dev/null && echo "Paused"'
alias resume-reading='pkill -CONT afplay 2>/dev/null && echo "Resumed"'
alias stop-reading='pkill -9 afplay 2>/dev/null; kill $(cat /tmp/read-aloud/pid 2>/dev/null) 2>/dev/null; echo "Stopped"'

# macOS Secure Input diagnostics — blocks Aerospace / Karabiner / etc. when latched.
# Common trigger: browser SSO extensions + Passwords Extension Helper.
secure-input() {
    local pid=$(ioreg -l -w 0 2>/dev/null | grep -oE 'SecureInputPID"=[0-9]+' | grep -oE '[0-9]+' | head -1)
    if [[ -z "$pid" ]]; then
        print -P "%F{green}✓%f Secure Input is not active — keyboard-tap apps work normally"
        return 0
    fi
    local proc=$(lsof -p "$pid" 2>/dev/null | awk '/txt.*REG.*MacOS\/[^\/]*$/ {n=split($NF,a,"/"); print a[n]; exit}')
    print -P "%F{yellow}⚠%f Secure Input active — PID $pid (${proc:-unknown})"
    print -P "   Aerospace / Karabiner / any keyboard-tap app is blocked."
    print -P ""
    print -P "   Fixes (try in order):"
    print -P "     1. Terminal.app → menu → Secure Keyboard Entry → toggle ON then OFF"
    print -P "     2. %F{cyan}secure-input-fix%f       # kill SSO agents (auto-respawn, non-destructive)"
    print -P "     3. Ctrl+Cmd+Q, unlock with typed password (not Touch ID)"
    print -P "     4. Reboot (last resort)"
    return 1
}

# One-shot remediation: kills the Chrome SSO / Passwords Extension auth agents
# that commonly leave Secure Input latched. They auto-respawn cleanly on the
# next SSO request. Does NOT touch Chrome itself.
secure-input-fix() {
    print -P "%F{cyan}→%f Killing SSO auth agents (auto-respawn, Chrome stays open)..."
    killall AppSSOAgent AppSSODaemon AuthenticationServicesAgent 2>/dev/null
    sleep 1
    secure-input
}

export PATH="$HOME/.local/bin:$PATH"

# Load private/work-specific configuration if it exists (gitignored). Keep last.
[[ -f ~/.config/zsh/.zshrc.private ]] && source ~/.config/zsh/.zshrc.private
