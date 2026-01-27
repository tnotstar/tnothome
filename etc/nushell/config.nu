# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# set up the configuration editor
$env.config.buffer_editor = "micro"

def uvcode [] {
	uv run ...(which code | get path) .
}

def up2starship [] {
	starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

def up2zoxide [] {
	zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
}

do --env {
	let ssh_agent_file = (
		$env.HOME | path join ".bitwarden-ssh-agent.sock"
	)

	if ($ssh_agent_file | path exists) {
		$env.SSH_AUTH_SOCK = $ssh_agent_file
	}
}
