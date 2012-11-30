' ----------------------------------------------------------------------------
' Copyright (c) 2012 Antonio Alvarado Hernández - All rights reserved
' ----------------------------------------------------------------------------
'
'   Licensed under the Apache License, Version 2.0 (the "License");
'   you may not use this file except in compliance with the License.
'   You may obtain a copy of the License at
'
'       http://www.apache.org/licenses/LICENSE-2.0
'
'   Unless required by applicable law or agreed to in writing, software
'   distributed under the License is distributed on an "AS IS" BASIS,
'   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
'   See the License for the specific language governing permissions and
'   limitations under the License.
'
' ----------------------------------------------------------------------------
' $Id$
' ----------------------------------------------------------------------------

Option Explicit

'
' WARNING: Following code was inspired (but it not copied) from
' http://www.winhelponline.com/articles/185/1/VBScripts-and-UAC-elevation.html
' any added bugs are mine, so go to the source article to get things fine!
'
Sub CheckForElevation
' Execute the current script with elevated privileges (if need it)
    Dim wmi, rs, os, version, shell

    ' Retrieve the major version number of the running OS
    Set wmi = GetObject("WinMgmts:{ImpersonationLevel=Impersonate}!\\.\Root\CimV2")
    Set rs = wmi.ExecQuery("SELECT * FROM Win32_OperatingSystem")
    For Each os in rs
        version = CInt(Left(os.Version, InStr(os.Version, ".")-1))
    Next

    ' If running OS is Windows Vista or above, re-exec with elevation
    If version >= 6 And WScript.Arguments.Length = 0 Then
        Set shell = CreateObject("Shell.Application")
        shell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName _
            & Chr(34) & " /UAC", "", "runas", 1
        WScript.Quit
    End If
End Sub

'
' WARNING: Following code was inspired (but it not copied) from
' http://www.winhelponline.com/blog/create-system-restore-point-quickly-using-script-in-windows-7-vista-and-xp
' any added bugs are mine, so go to the source article to get things fine!
'
Sub CreateSystemRestorePoint
' Create a system restore point, after asking user for its name
    Dim name, srp, rs

    ' First, ask user for the new srp's name
    name = "Manual Restore Point"
    name = Trim(InputBox("Enter a name for the new restore point", _
        "System Restore Point Creation Utility", name))
    If name = "" Then
        WScript.Echo "Information: Operation cancelled by user."
        Exit Sub
    End IF

    ' Then, try to create a new restore point with given name
    Set srp = GetObject("WinMgmts:{ImpersonationLevel=Impersonate}!\\.\Root\Default:SystemRestore")
    rs = srp.CreateRestorePoint(name, 0, 100)
    If rs <> 0 Then
        WScript.Echo "Error(" & rs & "): Unable to create the restore point."
        Exit Sub
    End If
    WScript.Echo "Information: Operation finished successfully!"
End Sub

CheckForElevation
CreateSystemRestorePoint

' EOF