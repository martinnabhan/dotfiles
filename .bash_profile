if [ -f ~/.bashrc ]; then . ~/.bashrc; fi 

# settings 
export PATH="/usr/local/bin:$PATH"
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PS1="\W: "
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export VISUAL=nvim
export EDITOR="$VISUAL"

# command history size
HISTSIZE=0.1
HISTFILESIZE=0.1

# command aliases
alias vim=nvim
alias sudo="sudo -i"
alias macupdate="sudo sh -c 'softwareupdate -ia && reboot'"

# rust cargo path
export PATH="$HOME/.cargo/bin:$PATH"

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

# use rg for listing path candidates
_fzf_compgen_path() {
  rg --files "$1" | with-dir "$1"
}

# use rg to generate the list for directory completion
_fzf_compgen_dir() {
  rg --files "$1" | only-dir "$1"
}

# use rg with fzf
export FZF_DEFAULT_COMMAND='rg --files --fixed-strings --ignore-case -g "!*.min.js" -g "!*.lock" -g "!package-lock.json"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf key bindings
stty discard undef
bind -x '"\C-o": search_files'
bind -x '"\C-l": search_all_files'
bind -x '"\C-p": search_inside_files'

search_files() {
  local files
  IFS=$'\n' files=($(fzf-tmux -i --query="$1" --multi --select-1 --exit-0 --preview "(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200"))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

search_all_files() {
  local files
  IFS=$'\n' files=($(rg --files -uu --fixed-strings --ignore-case -g "!*.min.js" -g "!*.lock" -g "!package-lock.json" | fzf-tmux -i --query="$1" --multi --select-1 --exit-0 --preview "(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200"))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

search_inside_files() {
  local files
  IFS=$':' files=($(rg --column --fixed-strings --no-heading --ignore-case --line-number -g "!*.min.js" -g "!*.lock" -g "!package-lock.json" .| fzf-tmux -i --query="$1" --multi --select-1 --exit-0 --delimiter ":" --nth "4.." --preview "ruby ~/.fzf/highlight.rb {1}:{2}"))
  [[ -n "$files" ]] && ${EDITOR:-vim} "+call cursor(${files[1]}, 0)" "${files[0]}"
}

# docker-compose auto completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi
export PATH="/usr/local/sbin:$PATH"

# z completion
if command -v brew >/dev/null 2>&1; then
	[ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh

  # z and fzf integration
  unalias z 2> /dev/null
  z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

# kill processes using fzf
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# edit profile
edit_profile() {
  $EDITOR ~/.bash_profile
}

# reload profile
reload_profile() {
  source ~/.bash_profile
}

# edit vimrc
vimrc() {
  $EDITOR ~/.config/nvim/init.vim
}
