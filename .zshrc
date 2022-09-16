# powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh completions
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(~/.zsh/completion $fpath)

# history
HISTORY_IGNORE="(history|ls|ls -la|ls -latr|mysql -h fr18*)"
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=100000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# autosuggest
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# path
export PATH=/usr/local/sbin:$PATH
export PATH=/Users/Shared/DBngin/mysql/8.0.19/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH

# variables
export BAT_STYLE=plain
export BAT_THEME=TwoDark
export CLICOLOR=1
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LSCOLORS=ExFxBxDxCxegedabagacad
export SSH_KEY_PATH="~/.ssh/rsa_id"

# load prompt
autoload -Uz compinit

# cache prompt
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# plugins
source /usr/local/opt/zplug/init.zsh
zplug load

# bash completions
autoload -U +X bashcompinit && bashcompinit

# aliases
alias vim=nvim
alias sudo="sudo -i"
alias -g chekcout=checkout
alias -g "git push -f"="git push --force-with-lease"

# fzf completion, key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
