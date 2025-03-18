# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall

# make completions case insensitive by default
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

# Aliases
alias cat="bat"
alias grep="grep -i"
alias ls="lsd -a"
alias open="xdg-open"
alias rg="rg -i"

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
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.zsh/zsh-autoswitch-virtualenv/autoswitch_virtualenv.plugin.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source ~/.zsh/zsh-z/zsh-z.plugin.zsh

# Syntax highlighting should always be the last
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

export EDITOR=nvim
export DISABLE_AUTO_TITLE="true"
# export GTK_THEME='Catppuccin-Mocha-Standard-Mauve-dark:dark'

# Loads the opam environment
eval $(opam env)
# eval $(opam env --switch=latest)
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

if [ -e /home/prabhat/.nix-profile/etc/profile.d/nix.sh ]; then . /home/prabhat/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[ -f "/home/prabhat/.ghcup/env" ] && . "/home/prabhat/.ghcup/env" # ghcup-env
