#
# ~/Local/etc/fish/conf.d/variables.fish
#

set -gx LS_OPTIONS --group-directories-first --color=auto

set -gx VISUAL nvim
set -gx EDITOR nvim

set -gx WINEPREFIX "$HOME/.wine" 

fish_add_path --prepend "$HOME/Local/bin" "$HOME/.local/bin"

# EOF
