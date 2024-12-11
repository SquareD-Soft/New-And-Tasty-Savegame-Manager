
#singleinstance, force
#NoTrayIcon

wintitle := "New And Tasty Savegame Manager"

sound_pitch := 400
sound_length := 150


; =================================================================================
; Load app config and locations ===================================================
; =================================================================================

configlocation := "cfg\config.ini"
if(!fileexist("cfg"))
configlocation := "config.ini"

iniread, location_savegame, %configlocation%, Info, location_savegame, 0
iniread, location_backup, %configlocation%, Info, location_backup, %A_ScriptDir%\savegame backups
iniread, backupNameStyle, %configlocation%, Settings, backupNameStyle, NNTSaveBackup
iniread, hotkey_createBackup, %configlocation%, Settings, hotkey_createBackup, F3
iniread, checkbox_enableHotkey, %configlocation%, Settings, enableHotkey, 1
iniread, checkbox_playSound, %configlocation%, Settings, playSound, 1

if (location_backup = A_ScriptDir "\savegame backups" and !fileexist(A_ScriptDir "\savegame backups"))
location_backup := A_ScriptDir

Hotkey, IfWinActive, ahk_exe NNT.exe
hotkey, %hotkey_createBackup%, createBackup_hotkey

if (checkbox_enableHotkey = 0)
hotkey, %hotkey_createBackup%, off

; Get savegame location ===========

if (location_savegame = 0 or !fileexist(location_savegame))
{
	if (fileexist("C:\Program Files (x86)\Steam\steamapps\common\Oddworld New n Tasty"))
	{
		gamelocation :=  "C:\Program Files (x86)\Steam\steamapps\common\Oddworld New n Tasty"
	}
	else
	{
		WinGet, gamelocation_exe, ProcessPath, ahk_exe NNT.exe
		SplitPath, gamelocation_exe ,, gamelocation
	}

	if(fileexist(gamelocation))
	{
		Loop, Files, %gamelocation%\savegame\* , D
		location_savegame_pre := A_LoopFileFullPath
	}

	if (fileexist( "\SaveSlotData.NnT"))
	{
		location_savegame := location_savegame_pre
		Iniwrite, %location_savegame%, %configlocation%, Info, location_savegame
	}
	else
	{
		settimer, gameProcessCheck, 1000
	}
}

errormessage_location_savegame := "Savegame location not found!`n`nStart the game to automatically detect and set`nthe location, or set it manually in the settings."
errormessage_location_backup := "Backup location not found!`n`nPlease set a valid location in the settings and`nmake sure the selected folder exists!"


; =================================================================================
; Style ===========================================================================
; =================================================================================

mainGuiW := 570
mainGuiH := 800

mainGuiX := ((A_screenWidth / 2) + (A_screenWidth / 4) - (mainGuiW / 2))
mainGuiY := ((A_screenHeight / 2 )  - ((mainGuiH + 26) / 2))

settingsButtonW := 80
settingsButtonX := mainGuiW - settingsButtonW -35

listY := 150
listH := mainGuiH - listY
columwidth_foldername := 200
columwidth_savegameDate := 200
columwidth_backupDate := mainGuiW - columwidth_foldername - columwidth_savegameDate -24


settingsGuiW := mainGuiW - (mainGuiW / 15)
settingsGuiH := 420


settingsGuiEditW := settingsGuiW - (settingsGuiW / 3)
settingsGuiEditH := 42


; =================================================================================
; GUIS ============================================================================
; =================================================================================

; Main gui ============

Gui, mainGui: new
Gui, +lastfound
mainguiId := winexist()
Gui, mainGui: color, 393939, 2f2f2f
Gui, mainGui: font, s11 cE1E1E1, arial
Gui, mainGui: add, button, vbutton_createBackup gcreateBackup  w130 h45 x20 y25, Create Backup
Gui, mainGui: add, button, vbutton_loadBackup gloadBackup x+40 yp w130 h45 disabled, Load Backup
Gui, mainGui: add, button, gshowSettings x%settingsButtonX% yp w%settingsButtonW% h45 , Settings

Gui, mainGui: add, text, gopen_savegameLocation x20 y+30, Current Savegame Modified: 
Gui, mainGui: add, text, vtext_currentSave gopen_savegameLocation x+20 w200 yp, -

Gui, mainGui: add, listView, vsavegameList glistEvent -Multi altsubmit x0 y%listY% w%mainGuiW% h%listH%,Foldername|Savegame Modified|Backup Time| #
LV_ModifyCol(1, columwidth_foldername)
LV_ModifyCol(2, columwidth_savegameDate)
LV_ModifyCol(3, columwidth_backupDate)
LV_ModifyCol(4, 0)
LV_ModifyCol(4, "Integer")

sortstatus_folderName := 0
sortstatus_dateCreated := 0


; Settings gui ============

Gui, settingsGui: new
Gui, settingsGui: color, 393939, 2f2f2f
Gui, settingsGui: font, s11 cE1E1E1, arial
Gui, settingsGui: +OwnerMainGui +ToolWindow +caption

Gui, settingsGui: add, text,  vtext_hotkey x20 y35, Hotkey: 
Gui, settingsGui: add, hotkey, vedit_hotkey x+20 yp-4 w130 0x200, %hotkey_createBackup%

Gui, settingsGui: add, checkbox, vcheckbox_enableHotkey gchangeCheckbox_enableHotkey x+20 yp4 checked%checkbox_enableHotkey%, Enable Hotkey
Gui, settingsGui: add, checkbox, vcheckbox_playSound gchangeCheckbox_playSound x+30 yp checked%checkbox_playSound%, Play Sound

Gui, settingsGui: add, text, x20 y+55, Backup Name Style
Gui, settingsGui: add, edit, vedit_backupNameStyle x20 w300 x+20 yp-2 -multi -WantReturn -wrap -number, %backupNameStyle% 

Gui, settingsGui: add, text, x20 y+40, Backup Location
Gui, settingsGui: add, edit, vedit_location_backup x20 w%settingsGuiEditW% h%settingsGuiEditH% y+15 disabled , %location_backup% 
Gui, settingsGui: add, button, gchangeLocation_backup x+30 yp w80 h%settingsGuiEditH%, Change

Gui, settingsGui: add, text, x20 y+30, Savegame Location
Gui, settingsGui: add, edit, vedit_location_savegame x20 w%settingsGuiEditW% h%settingsGuiEditH% y+15 disabled , %location_savegame% 
Gui, settingsGui: add, button, gchangeLocation_savegame x+30 yp w80 h%settingsGuiEditH%, Change

OnMessage(0x0006,"refreshCurrentSavegameText")

refreshlist(3, "SortDesc")
refreshCurrentSavegameText()

Gui, mainGui: show, w%mainGuiW% h%mainGuiH% x%mainGuiX% y%mainGuiY%, %wintitle%
return


; =================================================================================
; Create backup ===================================================================
; =================================================================================

createBackup_hotkey:

if (checkbox_playSound = 1 and fileexist(location_savegame) and fileexist(location_backup))
SoundBeep, %sound_pitch%, %sound_length%

createBackup:

if (!fileexist(location_savegame))
{
	msgbox, 48, ERROR, %errormessage_location_savegame%
	return
}

if(!fileexist(location_backup))
{
	msgbox, 48, ERROR, %errormessage_location_backup%
	return
}

copyError_create := 0
savenumber_next := 0

Loop, Files, %location_backup%\*.*, D
{
	savename := RegExReplace(A_LoopFileName, "\d")
	savenumber := strreplace(A_LoopFileName, backupNameStyle, "")
	if (A_LoopFileName != "AdditionalBackup" and savename = backupNameStyle and savenumber > savenumber_next)
	savenumber_next := savenumber
}

savenumber_next++

FileCreateDir, %location_backup%\%backupNameStyle%%savenumber_next%

Loop, Files, %location_savegame%\*.NnT
{
	if(instr(A_LoopFileName, "Settings"))
	continue
	filecopy, %location_savegame%\%A_LoopFileName%, %location_backup%\%backupNameStyle%%savenumber_next%\*.*
	if (errorLevel != 0)
	copyError_create := 1
}

if (copyError_create != 0) 
{
	msgbox, 48, ERROR, Failed to create backup!`n`nOne or more files could not be copied!
	return
}

refreshlist(3, "SortDesc")
return


; =================================================================================
; Load backup =====================================================================
; =================================================================================

loadBackup:

if (winexist("ahk_exe NNT.exe"))
{
	msgbox, 64,	Info, Game is still running. Please close the game first!
	return
}

if (!fileexist(location_savegame))
{
	msgbox, 48,	ERROR, %errormessage_location_savegame%
	return
}

if(!fileexist(location_backup))
{
	msgbox, 48,	ERROR, %errormessage_location_backup%
	return
}

rowNumber := LV_GetNext(0, F)
if (rowNumber < 1)
return

LV_GetText(backupToLoad, RowNumber , 1)
LV_GetText(savegameDate, RowNumber , 2)
LV_GetText(backupDate, RowNumber , 3)

msgboxtext=
(
Replace the current savegame files with the following backup?

Backup Name:  
%backupToLoad%

Last Modified:  
%savegameDate%

Backup Created:  
%backupDate%
)

msgbox, 52, Info, %msgboxtext%

Ifmsgbox Yes
{
	copyError_load := 0
	FileCreateDir, %location_backup%\AdditionalBackup
	Loop, Files, %location_savegame%\*.NnT
	{
		if(instr(A_LoopFileName, "Settings"))
		continue

		filecopy, %location_savegame%\%A_LoopFileName%, %location_backup%\AdditionalBackup\*.*, 1
		if (errorLevel != 0)
		copyError_load := 1
	}

	Loop, Files, %location_backup%\%backupToLoad%\*.NnT
	{
		if(instr(A_LoopFileName, "Settings"))
		continue

		filecopy, %A_LoopFileFullPath%, %location_savegame%\*.*, 1
		if (errorLevel != 0)
		copyError_load := 1
	}

	if (copyError_load != 0) 
	{
		msgbox, 48, ERROR, Failed to load backup!`n`nOne or more files could not be copied!
		return
	}
}

refreshCurrentSavegameText()
return


; =================================================================================
; Refresh savegame list ===========================================================
; =================================================================================

refreshlist(columnToSort, order)
{
	global location_backup, backupNameStyle
	Gui,mainGui:default

	LV_Delete()

	Loop, Files, %location_backup%\*.*, D
	{
		if (A_LoopFileName = "AdditionalBackup")
		continue

		validcheck := checkLocation(location_backup "\" A_LoopFileName)
	
		if (validcheck = 1)
		{
			backupNumber := strreplace(A_LoopFileName, backupNameStyle, "")
			date_formated_created := formatTime_dmyhm(A_LoopFileTimeCreated)
			FileGetTime, lastchanged , %A_LoopFileDir%\%A_LoopFileName%\SaveSlotData.NnT, M
			date_formated_lastchanged := formatTime_dmyhm(lastchanged)

			LV_Add(, A_LoopFileName, date_formated_lastchanged, date_formated_created, backupNumber)	
		}
	}

	LV_ModifyCol(columnToSort, order)
}


; =================================================================================
; Check for game process ==========================================================
; =================================================================================

gameProcessCheck:

if (fileexist(location_savegame "\SaveSlotData.NnT"))
{
	settimer,gameProcessCheck, off
	return
}

WinGet, gamelocation_exe, ProcessPath, ahk_exe NNT.exe
SplitPath, gamelocation_exe ,, gamelocation

if (fileexist(gamelocation "\savegame\"))
{
	settimer,gameProcessCheck, off

	Loop, Files, %gamelocation%\savegame\* , D
	location_savegame := A_LoopFileFullPath
	Iniwrite, %location_savegame%, %configlocation%, Info, location_savegame
	Guicontrol, settingsGui:, edit_location_savegame, %location_savegame%
	refreshCurrentSavegameText()
}
return


; =================================================================================
; Handle list event ===============================================================
; =================================================================================

listEvent:

rowNumber := LV_GetNext(0, F)

if (rowNumber >= 1 and fileexist(location_savegame) and fileexist(location_backup))
Guicontrol, mainGui: enable, button_loadBackup

if (rowNumber < 1)
Guicontrol, mainGui: disable, button_loadBackup


if (A_GuiEvent = "DoubleClick" and rowNumber >= 1 and fileexist(location_backup))
{
	LV_GetText(backupToLoad, RowNumber , 1)
	run, %location_backup%\%backupToLoad%
}

if (A_EventInfo = 1 and A_GuiEvent = "colclick")
{
	if (sortstatus_folderName = 0)
	{
		sortstatus_folderName := 1
		LV_ModifyCol(4, "Sort")
	}
	else
	{
		sortstatus_folderName := 0
		LV_ModifyCol(4, "SortDesc")
	}

	sortstatus_dateCreated := 0
}

if ((A_EventInfo = 2 or A_EventInfo = 3) and A_GuiEvent = "colclick")
{
	sortstatus_folderName := 0
}
return


; =================================================================================
; Change filepaths ================================================================
; =================================================================================

changeLocation_savegame:

Gui, settingsGui:+OwnDialogs
dirwindowname := "Select savegame location"

FileSelectFolder, filechoose_savegame ,*%location_savegame%,, %dirwindowname%

if (ErrorLevel = 0 and fileexist(filechoose_savegame))
{
	SplitPath, filechoose_savegame, filechoose_savegame_foldername
	
	if (filechoose_savegame_foldername = "SaveGame")
	{
		Loop, Files, %filechoose_savegame%\* , D
		filechoose_savegame := A_LoopFileFullPath
	}

	validcheck := checkLocation(filechoose_savegame)

	if(validcheck = 1)
	{
		location_savegame := filechoose_savegame
		Guicontrol, settingsGui:, edit_location_savegame, %location_savegame%
		Iniwrite, %location_savegame%, %configlocation%, Info, location_savegame
		refreshCurrentSavegameText()
	}
	else
	{
		msgbox, 48, ERROR, The selected filepath does not contain any savegame data! Please choose a valid filepath!
	}
}
return


changeLocation_backup:

Gui, settingsGui:+OwnDialogs

dirwindowname := "Select backup location"
FileSelectFolder, filechoose_backup ,*%location_backup%,, %dirwindowname%

if (ErrorLevel = 0 and fileexist(filechoose_backup))
{
	location_backup := filechoose_backup
	Guicontrol, settingsGui:, edit_location_backup, %location_backup%
	Iniwrite, %location_backup%, %configlocation%, Info, location_backup
	backupLocationChanged := 1
}
return


; =================================================================================
; Show settings gui ===============================================================
; =================================================================================

showSettings:

GuiControl, settingsGui: Focus, text_hotkey
Gui,Maingui: +disabled
WinGetPos , winX, winY,, %mainguiId%
settingsX := winX
settingsY := winY + 40
backupLocationChanged := 0
GuiControl, settingsGui:, edit_hotkey, %hotkey_createBackup%
GuiControl, settingsGui:, edit_location_backup, %location_backup%
Gui, settingsGui: show, w%settingsGuiW% h%settingsGuiH% x%settingsX% y%settingsY%, Settings
return


; =================================================================================
; Handle settings gui close =======================================================
; =================================================================================

SettingsguiGuiClose:

Gui, settingsGui: submit, nohide

if (edit_hotkey != hotkey_createBackup and edit_hotkey)
{
	hotkey, %hotkey_createBackup%, off
	hotkey_createBackup := edit_hotkey
	hotkey, %hotkey_createBackup%, createBackup_hotkey
	Iniwrite, %hotkey_createBackup%, %configlocation%, Settings, hotkey_createBackup
}

if (edit_backupNameStyle != backupNameStyle)
{
	backupNameStyle := edit_backupNameStyle
	backupNameStyle := RegExReplace(edit_backupNameStyle, "\d")
	GuiControl, settingsGui:, edit_backupNameStyle, %backupNameStyle%
	Iniwrite, %backupNameStyle%, %configlocation%, Settings, backupNameStyle
}

Gui,Maingui: -disabled
Gui, Settingsgui: Hide

if (backupLocationChanged = 1)
{
	backupLocationChanged := 0
	refreshlist(3, "SortDesc")
}

if (checkbox_enableHotkey = 1 and hotkey_createBackup)
hotkey, %hotkey_createBackup%, on
return




; =================================================================================
; Misc ============================================================================
; =================================================================================

; Format time ============

formatTime_dmyhm(time_unformated)
{
	FormatTime, time_formated , %time_unformated%, dd.MM.yy | HH:mm
	return time_formated
}


; Refresh current savegame text ============

refreshCurrentSavegameText()
{
	global location_savegame
	if (fileexist(location_savegame "\SaveSlotData.NnT"))
	{
		FileGetTime, lastchanged , %location_savegame%\SaveSlotData.NnT, M
		date_formated := formatTime_dmyhm(lastchanged)
		Guicontrol, mainGui:, text_currentSave, %date_formated%
	}
}


; Check if location is valid ============

checkLocation(location)
{
	isValid := 0

	if (fileexist(location "\SaveSlotData.NnT"))
	isValid := 1

	return isValid
}


; Open savegame location ============

open_savegameLocation:

if (fileexist(location_savegame) and A_GuiEvent = "DoubleClick")
run, %location_savegame%
return


; Change checkbox: Enable hotkey ============

changeCheckbox_enableHotkey:
Gui, settingsGui: submit, nohide
Iniwrite, %checkbox_enableHotkey%, %configlocation%, Settings, enableHotkey

if (checkbox_enableHotkey = 0)
hotkey, %hotkey_createBackup%, off
return


; Change checkbox: Play sound ============

changeCheckbox_playSound:
Gui, settingsGui: submit, nohide
Iniwrite, %checkbox_playSound%, %configlocation%, Settings, playSound
return


; Handle main gui close ============

mainguiguiclose:
exitapp
return


; Hotkey: Show all variables ============

^+f10::
ListVars
return
