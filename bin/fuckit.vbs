' Copyright (c) 2013 Antonio Alvarado Hernández - All rights reserved
'
' Licensed under the Apache License, Version 2.0 (the "License");
' you may not use this file except in compliance with the License.
' You may obtain a copy of the License at
'
'   http://www.apache.org/licenses/LICENSE-2.0
'
' Unless required by applicable law or agreed to in writing, software
' distributed under the License is distributed on an "AS IS" BASIS,
' WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
' See the License for the specific language governing permissions and
' limitations under the License.

Option Explicit

Const tsForReading   = 1
Const tsForWriting   = 2
Const tsForAppending = 8

Const fkPathName   = "Path"
Const fkTypeName   = "Type"
Const fkValueName  = "Value"
Const fkDeleteName = "Delete"

Function Main()
' This is the program's entry-point

    Dim Shell_, Filename_

    ' Get a shell instance to hack the Registry
    Set Shell_ = CreateObject("WScript.Shell")

    ' Bootstrap the configuration filename
    Filename_ = Replace(Wscript.ScriptFullName, ".vbs", ".ini", 1, 1, vbTextCompare)

    ' Apply all hacks & return the overall result
    Main = FuckThem(Shell_, Filename_)

End Function

Function FuckThem(Shell_, Filename_)
' Run all hacks specified in given configuration file

    Dim Config_, Feature_, Properties_

    ' Set return value to pessimistic mode
    FuckThem = False

    ' Read the configuration file
    Set Config_ = LoadConfig(Filename_)
    If Config_.Count = 0 Then
        MsgBox "Hmm. Nothing to do. Is everything ok?", vbExclamation, "Warning"
        Exit Function
    End If

    ' Apply all features in the config file
    For Each Feature_ In Config_.Keys
        Set Properties_ = Config_.Item(Feature_)
        If Not FuckIt(Shell_, Feature_, Properties_) Then
            MsgBox "Oops: something it's wrong with " & Feature_ & ". " & _
                   "Aborting current execution...", vbCritical, "Error"
            Exit Function
        End If
    Next

    ' Return the successfully value
    FuckThem = True

End Function

Function LoadConfig(Filename_)
' Load the configuration script with given filename

    Dim FS, Stream_, Config_

    ' Initialize the configuration object
    Set LoadConfig = CreateObject("Scripting.Dictionary")

    ' Check if configuration file exists
    Set FS = CreateObject("Scripting.FileSystemObject")
    If Not FS.FileExists(Filename_) Then
        Exit Function
    End If

    ' Initialize working variables
    Set Stream_ = FS.OpenTextFile(Filename_, tsForReading)

    ' Read the configuration file
    Do While Not Stream_.AtEndOfStream
        Dim Feature_, Properties_, Buffer_, Length_, BoT_, EoT_, Key_, Val_

        ' Read next line from input stream
        Buffer_ = Trim(Stream_.ReadLine)
        Length_ = Len(Buffer_)

        ' Check for begin of sections
        BoT_ = InStr(1, Buffer_, "[", vbTextCompare)
        If BoT_ > 0 Then
            EoT_ = InStr(BoT_, Buffer_, "]", vbTextCompare)
            If EoT_ > 0 Then
                ' Parse current section's name
                Feature_ = Trim(Mid(Buffer_, BoT_+1, EoT_-BoT_-1))

                ' Create the current section
                Set Properties_ = CreateObject("Scripting.Dictionary")
                If Not LoadConfig.Exists(Feature_) Then
                    LoadConfig.Add Feature_, Properties_
                End If
            End If
        End If

        ' Check for property entries
        BoT_ = InStr(1, Buffer_, "=",  vbTextCompare)
        If BoT_ > 0 Then
            ' Parse current property pair
            Key_ = Trim(Left(Buffer_, BoT_-1))
            Val_ = Trim(Right(Buffer_, Length_-BoT_))

            ' Add to current section
            Properties_.Add Key_, Val_
        End If
    Loop

End Function

Function FuckIt(Shell_, Feature_, Properties_)
' Apply given feature parameters and return the results

    Dim Path_, Type_, Value_, Delete_, Current_, Answer_

    ' Set the default function's return value
    FuckIt = False

    ' Verify if feature includes the path property (mandatory)
    If Not Properties_.Exists(fkPathName) Then
        Exit Function
    End If
    Path_ = Properties_.Item(fkPathName)

    ' Verify if the feature includes a type property (optional)
    If Properties_.Exists(fkTypeName) Then
        Type_ = Properties_.Item(fkTypeName)
    Else
        Type_ = Null
    End If

    ' Verify if the feature includes a value property (optional)
    If Properties_.Exists(fkValueName) Then
        Value_ = Properties_.Item(fkValueName)
    Else
        Value_ = Null
    End If

    ' Verify if the feature includes a delete property (optional)
    If Properties_.Exists(fkDeleteName) Then
        Delete_ = Properties_.Item(fkDeleteName)
    Else
        Delete_ = Null
    End If

    ' Retrieve the current Registry value
    Current_ = RegReadOrNull(Shell_, Path_)

    ' Verify if we need to remove the feature
    If Not IsNull(Delete_) And Not IsNull(Current_) Then
        ' Ask user to fuck this feature
        Answer_ = MsgBox(Feature_ & " has an undesired value. Could I fuck it up?", _
                         vbYesNo, "Fuck It!")
        If Answer_ <> vbYes Then
            FuckIt = True
            Exit Function
        End If

        ' Try to delete the Registry value
        FuckIt = RegDeleteOrFalse(Shell_, Path_)
        Exit Function
    End If

    ' Verify if we need to change the value
    If Current_ <> Value_ Then
        ' Ask user to fuck this feature
        Answer_ = MsgBox(Feature_ & " has not a good value. Could I fuck it up?", _
                         vbYesNo, "Fuck It!")
        If Answer_ <> vbYes Then
            FuckIt = True
            Exit Function
        End If

        ' Try to overwrite the Registry value
        FuckIt = RegWriteOrFalse(Shell_, Path_, Type_, Value_)
        Exit Function
    End If

    ' Assuming all was good :)
    FuckIt = True

End Function

Function RegReadOrNull(Shell_, Path_)
' Return the value read from given path, or Null if failed

    Dim Value_

    On Error Resume Next
    Value_ = Shell_.RegRead(Path_)

    If IsEmpty(Value_) Then
        Value_ = Null
    End If

    If Not IsNull(Value_) Then
        Value_ = CStr(Value_)
    End If

    On Error Goto 0
    RegReadOrNull = Value_

End Function

Function RegWriteOrFalse(Shell_, Path_, Type_, Value_)
' Overwrite value at given path and validate changes

    On Error Resume Next
    Shell_.RegWrite Path_, Value_, Type_

    On Error Goto 0
    RegWriteOrFalse = RegReadOrNull(Shell_, Path_) = Value_

End Function

Function RegDeleteOrFalse(Shell_, Path_)
' Delete value at given path and validate changes

    On Error Resume Next
    Shell_.RegDelete Path_

    On Error Goto 0
    RegDeleteOrFalse = IsNull(RegReadOrNull(Shell_, Path_))

End Function

WScript.Quit Main()

' EOF
