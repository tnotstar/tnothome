#
# ~/Local/etc/fish/conf.d/pdm.fish
#

if string match -q '*pep582*' $PYTHONPATH
    exit
end

pdm --pep582 fish | source

# EOF
