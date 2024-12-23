# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall

# make completions case insensitive by default
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle :compinstall filename '/home/prabhat/.zshrc'

autoload -Uz compinit
compinit

# Aliases
alias cat="bat"
alias ls="ls -a --color"
alias open="xdg-open"
alias sshk="kitten ssh"
alias rg="rg -i"
# alias yazi="/home/prabhat/yazi/target/release/yazi"


# Functions
# pigz() {
# 	tar -cvf - "$1" | pigz -p 12 > "$2".tar.gz
# }

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# zsh plugins
source ~/.zsh/zsh-256color/zsh-256color.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-autoswitch-virtualenv/autoswitch_virtualenv.plugin.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/zsh-z/zsh-z.plugin.zsh

# Syntax highlighting should always be the last
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export DISABLE_AUTO_TITLE="true"
# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/prabhat/.opam/opam-init/init.zsh' ]] || source '/home/prabhat/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
export GOPATH=/home/prabhat/go


[ -f "/home/prabhat/.ghcup/env" ] && . "/home/prabhat/.ghcup/env" # ghcup-env

# pnpm
export PNPM_HOME="/home/prabhat/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
