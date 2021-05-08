# Setup fzf
# ---------
if [[ ! "$PATH" == */home/erihan/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/erihan/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/erihan/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/erihan/.fzf/shell/key-bindings.bash"
