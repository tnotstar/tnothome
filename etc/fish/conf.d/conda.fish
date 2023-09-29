#
# ~/Local/etc/fish/conf.d/conda.fish

if ! test -f ~/Library/Conda/bin/conda
  exit 0
end

# N.B. to avoid `base` environment (auto)activation we need to
# issua the following command:
#
# $ conda config --set auto_activate_base false

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/tnotstar/Library/Conda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# EOF
