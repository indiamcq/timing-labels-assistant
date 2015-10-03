; Audacity hotkeys for segmenting Scripture for Scripture App Builder
; for stand alone use
;
; Version 1.2.4
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
; Revised by IM 2015-10-01
	; created keysub to remove duplicate code in each hotkey.
	; found way of selecting exe file window so language setting problem avoided. No more ToolDock
; Revised by IM 2015-10-02
	; now pass actual key stroke to keysub. Removed need for if statements when Audacity not active. Much easier to add a new key shuold it be needed.
	; also added some documentation in keysub
; Revised IM 2015-10-03
	; * Pause now suspends all other hotkeys and puts notification above tray icon
	; * Suspend in menu now in both right and left click
	; * Suspend also puts up notification of state
	; * Suspend disables the Restart at menu item
	; * Suspend also toggles check mark on the Suspend menu item

; 
;
; Allow only one instance
#SingleInstance force


; resmove the menu and create new entries
Menu, Tray, NoStandard
Menu, tray, Add, Restart timing at label..., restartAt ; Add the re-start menu
Menu, tray, Add, Suspend hot keys,     SuspendHandler  ; Add a suspend item
Menu, tray, Add, Exit,        ExitHandler     ; Add the exit item
; Left click menu items
Menu, restart, Add, Restart timing at label..., restartAt ; Add the re-start menu
Menu, restart, Add, Suspend hot keys,     SuspendHandler  ; Add a suspend item
Menu, restart, Add, Exit,        ExitHandler     ; Add the exit item


; if not compiled (i.e. used as a script), Set the menu icon and use 
if (A_IsCompiled <> 1) {
	iconfile := "Timing-Labels-Assistant.ico"
	menu, tray, Icon, %iconfile%
}


; ini file start =========================================================================================
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
; Update path if needed
curpath := RegExReplace(PhrasesFile, "^(..|....+)\\[^\\]+$", "$1")				; get curent path
if (curpath <> PhrasesPath)														; compare curpath to PharasePath, if different update the ini file
{
	IniWrite, %curpath%, %iniFile%, Path, PhrasesPath
}

; String opperation setup ======================================================================
; Read the content into a variable
FileRead, String , %PhrasesFile%

;Trim off the unwanted \ref line
newString := removeRef(String)
; Show the Phrases content
Run, Notepad.exe "%PhrasesFile%"

; come back here if cancel re-start dialog
norestart:

OnMessage(0x404,"AHK_NotifyTrayIcon") ; Check for left click on tray icon

; key difinitions start ==========================================================================

; Exit the app
pause::
	suspend
	gosub, suspendTip
return

:c?*:zx::
	ExitApp                        ; Exit the current script by typing zx
return

; Hotkeys start with a $ so they don't repeatedly fire themselves when not in Audacity.

$RButton::
	keytype := "{RButton}"
	gosub, keysub
return
	
$tab::
	keytype := "{tab}"
	gosub, keysub
return
	
$NumpadAdd::
	keytype := "{NumpadAdd}"
	gosub, keysub
return

$\::
	keytype := "\"
	gosub, keysub
return

; subroutines ===============================================================================================================

keysub:
	; provides the logic for processing two types of hot keys.
	IfWinActive, ahk_exe audacity.exe 
	{	
		; When Audacity is running
		if (keytype = "{RButton}") 
		{
			; handle right mouse button presses
			SetKeyDelay 200 
			send, {LButton}
			send ^b
			newString := getRef(newString)
		} 
		else
		{
			; handle on the fly keys NumpadAdd, tab or \ during playback of audio.
			SetKeyDelay 200 
			send, ^m
			newString := getRef(newString)	
		}
	} 
	else 
	{
		; If Audacity is not in focus then send the pressed key
		send, %keytype%
		ifWinNotExist, ahk_exe audacity.exe  ; exit app if Audacity is not running.
		{
			ExitApp
		}
	}
return

restartAt:
	InputBox, startString, Restart, Please enter the label you want to restart at. e.g. 5c ;Get the values to match
	if ErrorLevel ; Check for cancel button
	{
		ErrorLevel := 0		; reset the ErrorLevel
		goto, norestart		; return to start 
	}
	newString := removeRef(String)
	Loop 
	{
		
		newString := removeLine(newString)
		testRef := RegExReplace(newString, "^([^\t]+)\t[^$]*$","$1")
		if (newString = RegExReplace(newString, "^.+\r\n(.*)", "$1"))  ; At the end of the string so empty
		{ 
			MsgBox, 16, Fatal Error, The value you entered was not found! The label must exist in the phrases file. Try again.,5  ; Tell user to try again
			newString := removeRef(String)						; reset the string to the initial value
			goto, restartAt																; restart the process
		}
	} until testRef = startString	
return

ExitHandler:
  ExitApp
return

SuspendHandler: 
  suspend toggle
  gosub, suspendTip
return

suspendTip:
  if (A_IsSuspended)
	{
		TrayTip, Timing Labels Assistant, Hot Keys suspended`nPress [pause] to resume
	} else {
		TrayTip, Timing Labels Assistant, Hot Keys active
	}
	Menu, restart, ToggleEnable, Restart timing at label...
	Menu, restart, ToggleCheck, Suspend hot keys
return

	
; Functions =============================================================================================================


; Function to get ref and trim from front
getRef(s)
{
	;MsgBox , 8192, "Cur string", %s%, 3
	Ref := RegExReplace(s, "^([^\t]+)\t[^$]*$","$1")
	if ( s = removeLine(s)) {
		SetKeyDelay, 50
		send %Ref%{enter}
		SoundBeep, 750, 500
		ExitApp
	} else {
		SetKeyDelay, 50
		send %Ref%{enter}
		return removeLine(s)
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
removeLine(s)
{
	return RegExReplace(s, "^.+\r\n(.+)", "$1")
}
removeRef(s)
{
	return RegExReplace(s, "^\\ref	\\gl\r\n", "")
}
;
