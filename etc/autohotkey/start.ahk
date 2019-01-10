#NoEnv                       ; Recommended for performance and compatibility with
                             ; future AutoHotkey releases.
;#Warn                       ; Enable warnings to assist with detecting common errors.
SendMode Input               ; Recommended for new scripts due to its superior speed
                             ; and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

EnvGet, UserProfile, USERPROFILE

#c::
    Run, ConEmu64.exe, %UserProfile%
Return

#n::
    Run, Notepad.exe, %UserProfile%
Return

#k::
    Run, Calc.exe, %UserProfile%
Return

; EOF