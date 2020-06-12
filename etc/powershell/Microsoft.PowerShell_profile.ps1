#
# Copyright (c) 2020 Antonio Alvarado Hernández - All rights reserved
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#


#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Library\Conda\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

function Unalias {
	Param ($Name)

	if (Get-Command 'Remove-Alias' -ErrorAction SilentlyContinue) {
		Remove-Alias -Name "$Name" -Force
	} else {
		Remove-Item -Path "Alias:$Name" -Force
	}

	if (Get-Alias -name "$Name" -ErrorAction SilentlyContinue) {
		Unalias "$Name"
	}
}

New-Alias -Name    u -Value micro.exe
New-Alias -Name   vi -Value nvim.exe
New-Alias -Name  pad -Value notepad.exe
New-Alias -Name nvim -Value nvim-qt.exe

Unalias 'ls'
Unalias 'cp'
Unalias 'mv'
Unalias 'rm'
Unalias 'cat'
Unalias 'clear'

# EOF
