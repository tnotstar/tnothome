#
# ~/Local/etc/fish/config.fish
#

set --local privates $__fish_config_dir/fish_privates
if test -f $privates
    source $privates
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# EOF
