#
# ~/Local/etc/fish/conf.d/pdm.fish
#

if ! command -v pdm 2>&1 1> /dev/null
    exit 0
end

if string match -q '*pep582*' $PYTHONPATH
    exit
end

pdm --pep582 fish | source

# EOF
