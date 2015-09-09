; Audacity hotkeys for segmenting Scripture for Scripture App Builder
; for stand alone use
;
; Version 1.2.3
;
; Written by Ian McQuay
; 2015-Jun-20
; Revised by IM 2015-Jun-23
; Revised by IM 2015-Aug-12
	; fixed wrong output key in tab when not in Audacity
	; fixed wrong output key in \ when not in Audacity
	; added handling send once marker to \ key
	; File open dialog instead of file save
	; Cancel button exits script. As does Esc
	; added handling to copy old ini file to new ini name and delete old file
	; added icon if used as a script
; 
;
; Allow only one instance
#SingleInstance force
SetTitleMatchMode, 1
Menu, Tray, NoStandard
Menu, tray, Add, Suspend,     SuspendHandler  ; Add a suspend item
Menu, tray, Add, Exit,        ExitHandler     ; Add the exit item
Menu, restart, Add, Re-start timing at label? i.e. 5c, restartAt ; Add the re-start menu
Menu, restart, Add, Exit,        ExitHandler     ; Add the exit item


; if not compiled (i.e. used as a script), Set the menu icon and use 
if (A_IsCompiled <> 1) {
	iconfile := "Timing-Labels-Assistant.ico"
	menu tray, Icon, %iconfile%
}

; Variable for ini file
oldinifile := "Aud-SAB-assist.ini"
iniFile := "timing-labels-assistant.ini"
if (FileExist(oldiniFile)) {
	FileCopy, %oldinifile%, %inifile%
	FileDelete, %oldinifile%
} 
; Create ini file if needed
if (FileExist(iniFile)) {
} else {
	FileSelectFolder, PhrasesPath , \ , 1, Choose folder where Phrases files are found.
	IniWrite, %PhrasesPath%, %iniFile%, Path, PhrasesPath
}
;Read ini file 
IniRead, PhrasesPath, %iniFile%, Path, PhrasesPath , C:\

; Select phrases file
FileSelectFile, PhrasesFile , 1 , %PhrasesPath% , Select Phrase file for currrent chapter, Phrases (*.phrases)
if (ErrorLevel) {
	ExitApp
}

; Read the content into a variable
FileRead, String , %PhrasesFile%

;Trim off the unwanted first line
newString := RegExReplace(String, "^.+\r\n(.+)", "$1")
; Show the Phrases content
Run, Notepad.exe "%PhrasesFile%"

norestart:

OnMessage(0x404,"AHK_NotifyTrayIcon") ; Check for left click on tray icon

; Exit the app
#p::Pause                               ; Windows key p   Pauses execution of script
:c?*:zx::ExitApp                        ; Exit the current script by typing zx

; Hotkeys start with a $ so they don't fire themselves when not in Audacity.
$RButton::
	IfWinActive,  , ToolDock
	{
		SetKeyDelay 200 
		send, {LButton}
		send ^b
		newString := getRef(newString)
	} else {
		send, {RButton}
		IfWinNotExist , , ToolDock
		{
			ExitApp
		}
	}
	return
$tab::
	IfWinActive,  , ToolDock
	{
		SetKeyDelay 200 
		send, ^m
		newString := getRef(newString)	
	} else {
		send, {Tab}
		IfWinNotExist , , ToolDock
		{
			ExitApp
		}
	}
	return
	
$NumpadAdd::
	IfWinActive,  , ToolDock
	{
		SetKeyDelay 200 
		send, ^m
		newString := getRef(newString)	
	} else {
		send, {NumpadAdd}
		IfWinNotExist , , ToolDock
		{
			ExitApp
		}
	}
	return

$\::
	IfWinActive,  , ToolDock
	{
		SetKeyDelay 200 
		send, ^m
		newString := getRef(newString)	
	} else {
		send, \
		IfWinNotExist , , ToolDock
		{
			ExitApp
		}
	}
return

restartAt:
	InputBox, startString, Restart, Please enter the ref you want to restart at. ;Get the values to match
	if ErrorLevel ; Check for cancel button
	{
		ErrorLevel := 0		; reset the ErrorLevel
		goto, norestart		; return to start 
	}
	Loop 
	{
		newString := RegExReplace(newString, "^.+\r\n(.*)", "$1")
		testRef := RegExReplace(newString, "^([^\t]+)\t[^$]*$","$1")
		if (newString = RegExReplace(newString, "^.+\r\n(.*)", "$1"))  ; At the end of the string so empty
		{ 
			MsgBox, 16, Fatal Error, The value you entered was not found! The label must exist in the phrases file. Try again.,5  ; Tell user to try again
			newString := RegExReplace(String, "^.+\r\n(.+)", "$1")						; reset the string to the initial value
			goto, restartAt																; restart the process
		}
	} until testRef = startString	
return

ExitHandler:
  ExitApp
return

SuspendHandler: 
  suspend toggle
return
; Functions


; Function to get ref and trim from front
getRef(s)
{
	;MsgBox , 8192, "Cur string", %s%, 3
	Ref := RegExReplace(s, "^([^\t]+)\t[^$]*$","$1")
	if ( s = RegExReplace(s, "^.+\r\n(.+)", "$1")) {
		SetKeyDelay, 50
		send %Ref%{enter}
		SoundBeep, 750, 500
		ExitApp
	} else {
		SetKeyDelay, 50
		send %Ref%{enter}
		return RegExReplace(s, "^.+\r\n(.+)", "$1")
    }
}
AHK_NotifyTrayIcon(wParam, lParam)
{
 global 
 If lParam = 0x201
  ShowTrayPopup()
 return
}
ShowTrayPopup()
{
  Menu, restart, Show  
}
;