#NoTrayIcon
#AutoIt3Wrapper_Change2CUI=y
Global $sAutoitDir = RegRead('HKLM\SOFTWARE\AutoIt v3\Autoit', 'InstallDir')
If Not FileExists($sAutoitDir) Or @error Then
	MsgBox(64, "Au3-CLI", "Could not find autoit installDir, exiting.")
	Exit
EndIf


If Not @Compiled Then
	EnvUpdate()
	Global $sPathRegKey = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
	Global $sCompilerPath = $sAutoitDir & "\Aut2Exe\Aut2exe.exe"
	Global $sDesiredDir = @AppDataDir & "\au3"
	Global $sDesiredFullPath = $sDesiredDir & "\au3.exe"
	Global $aEnvs = StringSplit(RegRead($sPathRegKey, "PATH"), ";")
	Global $has_env = 0
	Global $has_exe = FileExists($sDesiredDir & "\au3.exe")

	For $i = 1 To $aEnvs[0]
		If $sDesiredDir == $aEnvs[$i] Then $has_env = 1
	Next

	If ($has_env + $has_exe) == 2 Then
		MsgBox(64, "Au3-CLI", "Au3-CLI is setup properly.")
		Exit
	EndIf

	; Add au3 to PATH env var
	If $has_env == 0 Then
		RegWrite($sPathRegKey, "PATH", "REG_EXPAND_SZ", RegRead($sPathRegKey, "PATH") & ";" & $sDesiredDir)
		EnvUpdate()
	EndIf

	; Compile
	If $has_exe == 0 Then
		If Not FileExists($sDesiredDir) Then DirCreate($sDesiredDir)
		RunWait(StringFormat('"%s" /in "%s" /out "%s" /console', $sCompilerPath, @ScriptFullPath, $sDesiredFullPath))
	EndIf

	MsgBox(64, "Au3-CLI", "Setup complete")
	Exit
EndIf

;Utility buffer
ConsoleWrite(@LF)

If $CmdLine[0] < 1 Then
	ConsoleWrite("Usage " & @LF & @LF & "au3 <file> <param1 param2 param3...>" & @LF & "au3 run <Script name>" & @LF)
	Exit
EndIf

; Check if any scripts should be ran
If $CmdLine[1] == "run" Then
	If $CmdLine[0] < 2 Then
		ConsoleWrite("Usage: 'au3 run <Script name>'" & @LF)
		Exit
	EndIf
	runScript($CmdLine[2])
	Exit
EndIf

Global $AutoitExe = $sAutoitDir & "\AutoIt3.exe"
Global $sFile = StringRight($CmdLine[1], 3) <> "au3" ? $CmdLine[1] & ".au3" : $CmdLine[1]
Global $sParams = StringReplace($CmdLineRaw, $CmdLine[1], "")
Global $iPid = Run($AutoitExe & ' "' & $sFile & '" ' & $sParams, "", Default, 0x6)
Global $sLine

While 1
	$sLine = StdoutRead($iPid)
	If @error Or Not ProcessExists($iPid) Then Exit
	If $sLine <> '' Then ConsoleWrite($sLine)
WEnd

While 1
	$sLine = StderrRead($iPid)
	If @error Then Exit
	ConsoleWrite($sLine)
	Exit
WEnd


Func runScript($scriptname)
	Local $aScripts = IniReadSection("au3.ini", "scripts")
	If @error Then
		ConsoleWrite("No scripts defined." & @LF)
		Exit
	EndIf

	For $i = 0 To $aScripts[0][0]
		If $aScripts[$i][0] == $scriptname Then
			ConsoleWrite(StringFormat("Running script '%s'", $scriptname) & @LF)
			Local $aScriptConent = StringSplit($aScripts[$i][1], "|")

			For $j = 1 To $aScriptConent[0]
				RunWait($aScriptConent[$j])
			Next

			Exit
		EndIf
	Next

	ConsoleWrite(StringFormat("Script '%s' does not exist", $scriptname) & @LF)
	Exit
EndFunc   ;==>runScript
