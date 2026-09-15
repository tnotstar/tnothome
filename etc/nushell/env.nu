# ~/.config/nushell/env.nu

$env.NU_LIB_DIRS = ($env.NU_LIB_DIRS | default [])

let custom_libs_dir = ($nu.default-config-dir | path join `scripts`)
if not ($custom_libs_dir in $env.NU_LIB_DIRS) {
    $env.NU_LIB_DIRS = ($env.NU_LIB_DIRS | append $custom_libs_dir)
}

$env.GDRIVE_PATH = ("~/Data/Gdrive" | path expand)
