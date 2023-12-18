#
# ~/Local/etc/fish/conf.d/fnm.fish
#

set -gx FNM_COREPACK_ENABLED true
set -gx FNM_RESOLVE_ENGINES true

fish_add_path -gaP ~/.fnm

fnm env | source

# EOF
