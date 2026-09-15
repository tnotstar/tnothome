#
# ~/.config/nushell/scripts/utools.nu
#

#
export def "check ip" [] {
    http get https://api.ipify.org
}

export def "uv code" [] {
    ^uv run ...(which code | get path) .
}

export def "uv agy" [] {
    ^uv run ...(which code | get path) .
}

export def up2starship [] {
    ^starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

export def up2zoxide [] {
    ^zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
}

# Adaptive 'fg' command with clean error handling
export def fg [job_id?: int] {
    if $nu.os-info.name == "linux" {
        try {
            if $job_id != null {
                job unfreeze $job_id
            } else {
                # If no ID is provided, try to unfreeze the last frozen job
                job unfreeze
            }
        } catch {
            # Catches 'nu::shell::job::none_to_unfreeze' and prints a clean message
            print "There are no frozen jobs in the background."
        }
    } else if $nu.os-info.name == "windows" {
        # Do nothing silently on Windows
    }
}

# Stolen from: https://github.com/nushell/nu_scripts/blob/main/modules/formats/from-env.nu
def "upscale-variables" [input: string, acc: record] {
    let matches = ($input | parse -r '\$\{(?<variable>[^}]+)\}')

    if ($matches | is-empty) {
        $input
    } else {
        $matches | reduce -f $input {|match, current|
            let name = $match.variable
            let value = (
                $acc
                    | get --optional $name
                    | default ($env | get --optional $name | default $"${($name)}")
            )
            $current | str replace $"${($name)}" $value
        }
    }
}

# Works with version 0.109.1
# Converts a .env file into a record
# may be used like this: open .env | load-env
# works with quoted and unquoted .env files
export def "from env" []: string -> record {
    lines
        | split column '#' # remove comments
        | get column0
        | parse "{name}={value}"
        | update value {
            str trim                          # Trim whitespace between value and inline comments
                | str trim -c '"'             # unquote double-quoted values
                | str trim -c "'"             # unquote single-quoted values
                | str replace -a "\\n" "\n"   # replace `\n` with newline char
                | str replace -a "\\r" "\r"   # replace `\r` with carriage return
                | str replace -a "\\t" "\t"   # replace `\t` with tab
            }
        | reduce -f {} {|row, accumulated|
            $accumulated | insert $row.name (upscale-variables $row.value $accumulated)
        }
}

export def gdrive [action: string] {
    let mount_path = $env.GDRIVE_PATH

    if $action == "on" {
        if ($mount_path | path exists) == false {
            mkdir $mount_path
        }
        print $"Mounting Google Drive in ($mount_path)..."
        ^rclone mount Gdrive: $mount_path --vfs-cache-mode full --daemon
    } else if $action == "off" {
        print $"Unmounting Google Drive from ($mount_path)..."
        ^fusermount -uz $mount_path
    } else {
        print $"Invalid argument `($action)`, use `gdrive on` or `gdrive off`"
    }
}
