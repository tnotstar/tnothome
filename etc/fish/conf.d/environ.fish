#
# ~/Local/etc/fish/conf.d/environ.fish
#

set -gx MESA_DEBUG silent   # a work-around to quiet firefox's warning messages

set -gx LS_OPTIONS --group-directories-first --color=auto

set -gx VISUAL nvim
set -gx EDITOR nvim

set -gx WINEPREFIX "$HOME/.wine" 

set -gx BUILDKIT_PROGRESS plain

fish_add_path --prepend "$HOME/Local/bin" "$HOME/.local/bin"

# EOF
