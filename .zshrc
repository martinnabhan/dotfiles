# powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh completions
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(~/.zsh/completion $fpath)

# history
HISTORY_IGNORE="(history|ls*)"
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=100000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# autosuggest
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# volta
export PATH="$HOME/.volta/bin:$PATH"

# variables
export CLICOLOR=1
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PHP_CS_FIXER_IGNORE_ENV=true
export GEMINI_API_KEY=

# load prompt
autoload -Uz compinit
compinit

{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# bash completions
autoload -U +X bashcompinit && bashcompinit

# aliases
alias vim=nvim
alias sudo="sudo -i"
alias -g chekcout=checkout
alias -g "git push -f"="git push --force-with-lease"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# autocomplete ssh
_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

# use fd with fzf
export FZF_DEFAULT_COMMAND='fd --type f'

# use fd instead of the default find
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# search files using fzf with ctrl + t
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf one dark theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,fg+:#ffffff,bg+:#4b5263,hl+:#e5c07b
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
'

# functions
edit_profile() {
  $EDITOR ~/.zshrc
}

reload_profile() {
  source ~/.zshrc
}

vimrc() {
  $EDITOR ~/.config/nvim/init.vim
}

# powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

autoload -Uz _zinit

(( ${+_comps} )) && _comps[zinit]=_zinit

zinit load agkozak/zsh-z
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit load lukechilds/zsh-better-npm-completion

zinit ice wait lucid
zinit load Aloxaf/fzf-tab

zinit ice wait lucid
zinit load zsh-users/zsh-syntax-highlighting

zinit light romkatv/powerlevel10k

# fzf
source <(fzf --zsh)

# db clients
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

. "$HOME/.local/bin/env"
