#
# ~/Local/etc/fish/conf.d/fnm.fish
#

if ! test -d "$HOME/.fnm"
  exit 0
end

set -gx FNM_COREPACK_ENABLED true
set -gx FNM_RESOLVE_ENGINES true

fish_add_path -gaP ~/.fnm

fnm env | source

# EOF
