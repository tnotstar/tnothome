#
# ~/Local/etc/elvish/rc.elv
#

use path

if (path:is-dir ~/Library/Neovim) {
    set paths = [~/Library/Neovim $@paths]
}

if (path:is-dir /usr/local/go/bin) {
    set paths = [/usr/local/go/bin $@paths]
}

if (path:is-dir ~/Library/Go) {
    set E:GOPATH = ~/Library/Go
}

if (path:is-dir $E:GOPATH/bin) {
    set paths = [$E:GOPATH/bin $@paths]
}

if (path:is-dir ~/Library/System/bin) {
    set paths = [~/Library/System/bin $@paths]
}

if (path:is-dir ~/Local/bin) {
    set paths = [~/Local/bin $@paths]
}

eval (carapace _carapace elvish | slurp)
eval (starship init elvish --print-full-init | slurp)

fn ls {|@args| e:ls --color $@args}
fn cp {|@args| e:cp -i $@args}
fn mv {|@args| e:mv -i $@args}
fn rm {|@args| e:rm -i $@args}
fn vi {|@args| nvim $@args}

set E:EDITOR = vi
