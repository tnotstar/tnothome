#
# ~/Local/etc/fish/config.fish
#

set --local privates $__fish_config_dir/fish_privates
if test -f $privates
    source $privates
end

# EOF
