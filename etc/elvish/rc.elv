#
# ~/Local/etc/elvish/rc.elv
#

use path

fn prepend_paths_with_dir {|@args|
    if (and (> (count $args) 0) (path:is-dir $args[0])) {
        set paths = [$args[0] $@paths]
    }
}

prepend_paths_with_dir /usr/local/go/bin

if (and (eq $E:GOPATH '') (path:is-dir ~/Library/Go)) {
    set E:GOPATH = ~/Library/Go
}

prepend_paths_with_dir $E:GOPATH/bin

if (and (eq $E:CARGO_HOME '') (path:is-dir ~/Library/Cargo)) {
    set E:CARGO_HOME = ~/Library/Cargo
}
prepend_paths_with_dir $E:CARGO_HOME/bin

prepend_paths_with_dir ~/Library/Neovim
prepend_paths_with_dir ~/Library/System/bin
prepend_paths_with_dir ~/Local/bin

#eval (carapace _carapace elvish | slurp)
eval (starship init elvish --print-full-init | slurp)

fn ls {|@args| e:ls --color $@args}
fn cp {|@args| e:cp -i $@args}
fn mv {|@args| e:mv -i $@args}
fn rm {|@args| e:rm -i $@args}
fn vi {|@args| e:nvim $@args}

fn open {|@args| e:cmd \/c start "" $@args}
fn mamba {|@args| e:micromamba $@args}

fn shmypass {
    if (has-env GOPASS_MYPASS_ID) {
        e:gopass show -c $E:GOPASS_MYPASS_ID
    } else {
        echo "Oops: Environment variable GOPASS_MYPASS_ID has not been set"
    }
}

set-env EDITOR vi

