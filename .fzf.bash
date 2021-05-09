# Setup fzf
# ---------
if [[ ! "$PATH" == *~/.config/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/erihan/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "~/.config/nvim/plugged/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "~/.config/nvim/plugged/fzf/shell/key-bindings.bash"
