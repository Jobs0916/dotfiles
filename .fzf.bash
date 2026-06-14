# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dark/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/dark/.fzf/bin"
fi

eval "$(fzf --bash)"
