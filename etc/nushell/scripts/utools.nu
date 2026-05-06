#
# ~/.config/nushell/scripts/utools.nu
#

#
export def "check ip" [] {
	http get https://api.ipify.org
}

export def "uv code" [] {
	uv run ...(which code | get path) .
}

export def "uv agy" [] {
	uv run ...(which code | get path) .
}

export def up2starship [] {
	starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

export def up2zoxide [] {
	zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
}
