#
# ~/Local/etc/fish/conf.d/golang.fish
#

set -gx GOPATH "$HOME/Library/Go:$HOME/Workspaces/Go"

fish_add_path -gaP ~/Library/Go/bin
fish_add_path -gaP ~/Workspaces/Go/bin

# EOF
