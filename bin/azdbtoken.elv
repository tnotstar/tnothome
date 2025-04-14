#!elvish

use str

var resource-url = 'https://database.windows.net'
var plink-options = [-A -T -X -agent -ssh $E:REMOTE_SESSION]

echo (az account get-access-token --resource $resource-url --output json | from-json)[accessToken] ^
	| tr -d "\n" | iconv -f ascii -t UTF-16LE ^
		| plink $@plink-options "use unix; set unix:umask = (num 0o77); cat > ~/.cache/az/jwtoken.bin"
