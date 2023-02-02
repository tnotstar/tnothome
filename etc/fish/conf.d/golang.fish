#
# ~/Local/etc/fish/conf.d/golang.fish
#

set -gx GOPATH "$HOME/Library/Golang:$HOME/Workspaces/Golang"

fish_add_path -gaP ~/Library/Golang/bin
fish_add_path -gaP ~/Workspaces/Golang/bin

# EOF
