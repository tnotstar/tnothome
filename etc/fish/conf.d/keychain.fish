#
# ~/Local/etc/fish/conf.d/keychain.fish
#

# Stolen from https://superuser.com/a/1727657/50903

if status is-login
    and status is-interactive
    and command -v keychain
    # To add a key, set -Ua SSH_KEYS_TO_AUTOLOAD keypath
    # To remove a key, set -U --erase SSH_KEYS_TO_AUTOLOAD[index_of_key]
    keychain --eval $SSH_KEYS_TO_AUTOLOAD | source
end

# EOF
