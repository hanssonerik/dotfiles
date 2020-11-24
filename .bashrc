#!/bin/bash


# Install ag, nvim, fzf, tmux
# sudo apt-get update
# sudo apt-get install tmux silversearcher-ag neovim fzf

#######################################################
## FUNCTIONS
#######################################################

# Extract argument matching any supplied flag
# will echo value after first match and return 
#
# use: 'extract_arg_matching -a,-all,--a $@'
# returns 1 if value after a flag is empty
extract_arg_matching() {
   IFS=',|' read -ra valid_flags <<< "$1"

    while [ "$2" ]; do
        if [[ " ${valid_flags[@]} " =~ " $2 " ]]; then
            local tmp=$2
            shift
            has_value $2 2>/dev/null  || (echo "param $tmp has no value" >&2 && return 1);
            echo $2
            return 0
        else
            echo $"'${2}' is not a valid argument flag" >&2 
            return 1
        fi
        shift
    done
}

# FZF find dir and change to it
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

git_repo_config() {
    git config user.name "Erik Hansson"
    git config user.email "$1"
    cat .git/config
}

# Validate that a file exists and has read permissions
is_valid_file_path() {
    [ ! -r "$1" ] && echo "Could not find file at '$1'" >&2 && return 1
    return 0;
}


# String is not empty
has_value() {
    [ -z  "$1" ] >&2 && echo "No value" >&2 && return 1
    return 0;
}


# Source script if it exists and has read permission
source_if_exists() {
    local SCRIPT_PATH=$(extract_arg_matching -p,--p $@)
    has_value $SCRIPT_PATH 2>/dev/null || return 1
    is_valid_file_path $SCRIPT_PATH || return 1

    source $SCRIPT_PATH
}


# Format git branch for PS1 output
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}


# Append to path only if path not already found
append_to_path() {
    if [[ ! "$PATH" == *${1}* ]]; then
      export PATH="${PATH:+${PATH}:}$1"
    fi
}



#######################################################
# SOURCE
#######################################################

# Private aliases
source_if_exists -p ~/.bash_aliases_private

# Source to ensure git auto complete
source_if_exists -p /usr/share/bash-completion/completions/git

# Setup Fuzzy Finder
source_if_exists -p ~/.fzf.bash



#######################################################
# EXPORTS
#######################################################

#  Change prompt
export PS1="\n\u@\h\[\033[32m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \n-> "



#######################################################
# FZF
#######################################################

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_COMPLETION_OPTS='+c -x'

#######################################################
# PATHS
#######################################################
GIT_NOTES_PATH="~/git"

append_to_path /usr/local/go/bin
append_to_path ~/.local/bin
append_to_path /opt/mssql-tools/bin
append_to_path /home/erihan/.fzf/bin




#######################################################
# ALIAS
#######################################################

## ALIAS - Git
alias glp="git log --pretty=oneline"
alias gd="git diff HEAD -- "
alias gdm="git diff origin/master..HEAD"
alias grem="git reset HEAD -- "
alias gadd="git add "
alias greset="git checkout HEAD -- "
alias gr="git reset HEAD -- "
alias gl="git log -p"
alias gs="git status"
alias ghelp="cat $GIT_NOTES_PATH"
alias gshowpatch="git rebase --show-current-patch"
alias gprune="git branch --merged | egrep -v '(^\*|master|dev)' | xargs git branch -d"
## ALIAS -  Always ask on remove
alias rmd="rm -Rfv"
alias rm="rm -iv"
alias vim="vi"
alias ls="tree -L 1 --du -h -p -D --dirsfirst -C"
alias brc="vim ~/.bashrc"
alias sc="cat ~/dev/configuration/semantic-commits-messages"
alias lint="yarn build && yarn lint && yarn lint:css && yarn test:ci"
alias lintcss="sudo yarn build && yarn lint && yarn lint:css && yarn test:ci && npx prettier -c src"


## VI - Set VI mode to terminal
set -o vi
set vi-cmd-mode-string "\1\e[2 q\2"
set vi-ins-mode-string "\1\e[6 q\2"
set convert-meta on


## VI - Default editor on 'v' in normal mode
export VISUAL=vim
export EDITOR=vim


#######################################################
# TMUX
#######################################################

# $- contains i if shell is interactive
# to prevent tmux session from starting if not interactive shell
if [[ $- != *i* ]]; then
    echo "not interactive";
    return 0;
fi


TMUX_SESSION=develop
if ! tmux has-session -t $TMUX_SESSION 2> /dev/null; then
     echo "Starting new tmux session"
     tmux -2 new-session -d -A -s $TMUX_SESSION
     tmux rename-window 'Develop'
     # Upper left
     tmux send-keys "cd ~/dev/stampen/mina-sidor-frontend && clear" C-m
     # tmux send-keys -R "echo a" C-m

     #  Upper right
     tmux split-window -h
     tmux send-keys "cd ~/dev/stampen/mina-sidor-frontend && clear" C-m
     # tmux send-keys -R "echo b" C-m
 
     # Set default pane
     tmux select-pane -t 2
 
     # Set default window
     tmux select-window -t $TMUX_SESSION:1
     
     # Attach to session
     tmux -2 attach-session -t $TMUX_SESSION
 else
     # attatch if not a tmux shell
     if [ -z $TMUX ]; then 
        tmux -2 attach-session -t $TMUX_SESSION
     fi
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
