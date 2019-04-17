fpath=(/usr/local/share/zsh-completions $fpath)

# history
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# theme
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$''
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$''
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv dir vcs)
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_to_last'

# path
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.fzf/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export VISUAL=nvim
export EDITOR="$VISUAL"
export SSH_KEY_PATH="~/.ssh/rsa_id"

#source $(dirname $(gem which colorls))/tab_complete.sh

# load prompt, completions, bash completions
autoload -Uz compinit
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
source ~/.zsh_plugins.sh

# bash completions
autoload -U +X bashcompinit && bashcompinit

# aliases
alias vim=nvim
alias sudo="sudo -i"

# fzf completion, key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autocomplete ssh known hosts and config
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

# use rg with fzf
# export FZF_DEFAULT_COMMAND='rg --files --fixed-strings --ignore-case -g "!*.min.js" -g "!*.lock" -g "!package-lock.json"'

# use rg for listing path candidates
# _fzf_compgen_path() {
#   rg --files "$1" | with-dir "$1"
# }
# 
# # use rg to generate the list for directory completion
# _fzf_compgen_dir() {
#   rg --files "$1" | only-dir "$1"
# }

# use fd with fzf
export FZF_DEFAULT_COMMAND='fd --type f'

# Use fd instead of the default find
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf one dark
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
'

# fzf key bindings
bindkey '^O' search_files
bindkey '^L' search_all_files
bindkey '^P' search_inside_files

search_files() {
  local files
  files=($(fzf --preview "ruby ~/.fzf/highlight.rb {1}:{2}"))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
zle -N search_files

search_all_files() {
  local files
  files=($(fzf --preview "ruby ~/.fzf/highlight.rb {1}:{2}"))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
zle -N search_all_files search_all_files

search_inside_files() {
  local files
  files=($(rg --column --fixed-strings --no-heading --ignore-case --line-number -g "!*.min.js" -g "!*.lock" -g "!package-lock.json" .| fzf-tmux -i --query="$1" --multi --select-1 --exit-0 --delimiter ":" --nth "4.." --preview "ruby ~/.fzf/highlight.rb {1}:{2}"))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
zle -N search_inside_files search_inside_files

# edit profile
edit_profile() {
  $EDITOR ~/.zshrc
}

# reload profile
reload_profile() {
  source ~/.zshrc
}

# edit vimrc
vimrc() {
  $EDITOR ~/.config/nvim/init.vim
}

# brew install plugin
bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do brew install $prog; done;
  fi
}

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/martin/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/martin/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/martin/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/martin/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh

# pyenv (loaded async with davidparsson/zsh-pyenv-lazy)
# eval "$(pyenv init -)"

# pyenv-virtualenv (load .python-version virtualenv automatically)
# eval "$(pyenv virtualenv-init -)"

# nvm
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
#
# nvm async
declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)

NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")
NODE_GLOBALS+=("nvim")

load_nvm () {
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done
