#
# ~/Local/etc/fish/conf.d/asdf.fish
#

set -x ASDF_DIR /opt/asdf-vm

if test -r "$ASDF_DIR/asdf.fish"
    source "$ASDF_DIR/asdf.fish"
end

# EOF
