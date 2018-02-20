if [ -f ~/.bashrc ]; then . ~/.bashrc; fi 

# settings 
export PATH="/usr/local/bin:$PATH"
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PS1="\W: "
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
export CLICOLOR=1
export VISUAL=vim
export EDITOR="$VISUAL"

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
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# open files in vim with fzf using ctrl + o
stty discard undef
bind -x '"\C-o": vim $(fzf);'
