
#singleinstance, force
#NoTrayIcon

wintitle := "New And Tasty Savegame Manager"

sound_pitch := 400
sound_length := 150


; =================================================================
; Load app config and locations ===================================
; =================================================================

configlocation := "cfg\config.ini"

FileCreateDir, cfg
FileCreateDir, save backups

iniread, location_savegame, %configlocation%, info, location_savegame, 0
iniread, location_backup, %configlocation%, info, location_backup, %A_ScriptDir%\save backups
iniread, backupNameStyle, %configlocation%, settings, backupNameStyle, NNTSaveBackup
iniread, hotkey_createBackup, %configlocation%, settings, hotkey_createBackup, F9
iniread, checkbox_playsound, %configlocation%, settings, playSound, 1

Hotkey, IfWinActive, ahk_exe NNT.exe
hotkey, %hotkey_createBackup%, createBackup_hotkey


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

	if (fileexist(gamelocation "\savegame\"))
	{
		Loop, Files, %gamelocation%\savegame\* , D
		location_savegame := A_LoopFileFullPath
		iniwrite, %location_savegame%, %configlocation%, info, location_savegame
	}
	else
	{
		settimer, gameProcessCheck, 500
	}
}


; =================================================================
; Style ===========================================================
; =================================================================

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


; =================================================================
; GUIS ============================================================
; =================================================================

; Maingui ============

Gui, mainGui: new
Gui, +lastfound
mainguiId := winexist()
Gui, mainGui: color, 393939, 2f2f2f
Gui, mainGui: font, s11 cE1E1E1, arial
Gui, mainGui: add, button, vbutton_createBackup gcreateBackup  w130 h45 x20 y25 disabled, Create Backup
Gui, mainGui: add, button, vbutton_loadBackup gloadBackup x+40 yp w130 h45 disabled, Load Backup
Gui, mainGui: add, button, gshowSettings x%settingsButtonX% yp w%settingsButtonW% h45 , Settings

Gui, mainGui: add, text, gopen_savegameLocation x20 y+30, Current savegame - Last modified: 
Gui, mainGui: add, text, vtext_currentSave gopen_savegameLocation x+20 w200 yp, -

Gui, mainGui: add, listView, vsavegameList glistEvent -Multi altsubmit x0 y%listY% w%mainGuiW% h%listH%,Foldername|Savegame Modified|Backup Time| #
LV_ModifyCol(1, columwidth_foldername)
LV_ModifyCol(2, columwidth_savegameDate)
LV_ModifyCol(3, columwidth_backupDate)
LV_ModifyCol(4, 0)
LV_ModifyCol(4, "Integer")


sortstatus_folderName := 0
sortstatus_dateCreated := 0

if (fileexist(location_savegame))
Guicontrol, mainGui: enable, button_createBackup

gosub, refreshlist
Gui, mainGui: show, w%mainGuiW% h%mainGuiH% x%mainGuiX% y%mainGuiY%, %wintitle%


; Settingsgui ============

Gui, settingsGui: new
Gui, settingsGui: color, 393939, 2f2f2f
Gui, settingsGui: font, s11 cE1E1E1, arial
Gui, settingsGui: +OwnerMainGui +ToolWindow +caption

Gui, settingsGui: add, text,  vtext_hotkey x20 y35, Hotkey: 
Gui, settingsGui: add, hotkey, vedit_hotkey x+20 yp-4 w100 0x200, %hotkey_createBackup%

Gui, settingsGui: add, checkbox, vcheckbox_playsound gchangeCheckbox_playSound x+70 yp4 checked%checkbox_playsound%, Play Sound

Gui, settingsGui: add, text, x20 y+55, Backup Name Style
Gui, settingsGui: add, edit, vedit_backupNameStyle x20 w300 x+20 yp-2 -multi -WantReturn -wrap -number, %backupNameStyle% 

Gui, settingsGui: add, text, x20 y+40, Savegame Location
Gui, settingsGui: add, edit, vedit_location_savegame x20 w%settingsGuiEditW% h%settingsGuiEditH% y+15 disabled , %location_savegame% 
Gui, settingsGui: add, button, gchangeLocation_savegame x+30 yp w80 h%settingsGuiEditH%, Change

Gui, settingsGui: add, text, x20 y+30, Backup Location
Gui, settingsGui: add, edit, vedit_location_backup x20 w%settingsGuiEditW% h%settingsGuiEditH% y+15 disabled , %location_backup% 
Gui, settingsGui: add, button, gchangeLocation_backup x+30 yp w80 h%settingsGuiEditH%, Change

refreshCurrentSavegameText()
OnMessage(0x0006,"refreshCurrentSavegameText")

return


; =================================================================
; Create backup ===================================================
; =================================================================

createBackup_hotkey:

if (checkbox_playsound = 1 and fileexist(location_savegame) and fileexist(location_backup))
SoundBeep , %sound_pitch%, %sound_length%

createBackup:

if (!fileexist(location_savegame))
{
	msgbox, 48,	ERROR, Savegame location not found!
	return
}


if(!fileexist(location_backup))
{
	msgbox, 48,	ERROR, Backup location not found!
	return
}

error := 0
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

Loop, Files, %location_savegame%\*
{
	if(instr(A_LoopFileName, "Settings"))
	continue
	filecopy, %location_savegame%\%A_LoopFileName%, %location_backup%\%backupNameStyle%%savenumber_next%\*.*
	if (errorLevel != 0)
	error := 1
}

if (error != 0) 
{
	MsgBox, 48, ERROR, Failed to create backup!
	return
}

goto, refreshlist

return


; =================================================================
; Load backup =====================================================
; =================================================================

loadBackup:

if (winexist("ahk_exe NNT.exe"))
{
	msgbox, 64,	Info, Game is still running. Please close the game first!
	return
}

if (!fileexist(location_savegame))
{
	msgbox, 48,	ERROR, Savegame location not found!
	return
}

if(!fileexist(location_backup))
{
	msgbox, 48,	ERROR, Backup location not found!
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
Replace current savegame files with this backup?

Name:                      
%backupToLoad%

Last modified:        
%savegameDate%

Created:                  
%backupDate%
)

msgbox, 52, Info, %msgboxtext%

IfMsgBox Yes
{
	; Create an additional backup of the current savegame file ===========

	FileCreateDir, %location_backup%\AdditionalBackup
	Loop, Files, %location_savegame%\*
	{
		if(instr(A_LoopFileName, "Settings"))
		continue
		filecopy, %location_savegame%\%A_LoopFileName%, %location_backup%\AdditionalBackup\*.*, 1
	}

	; Copy backup files to savegame location ===========

	Loop, Files, %location_backup%\%backupToLoad%\*
	{
		if(instr(A_LoopFileName, "Settings"))
		continue

		filecopy, %A_LoopFileFullPath%, %location_savegame%\*.*, 1
	}
	
}

refreshCurrentSavegameText()

return


; =================================================================
; Refresh savegame list ===========================================
; =================================================================

refreshlist:

Gui,mainGui:default

LV_Delete()

Loop, Files, %location_backup%\*.*, D
{
	if (A_LoopFileName = "AdditionalBackup")
	continue

	backupNumber := strreplace(A_LoopFileName, backupNameStyle, "")
	FormatTime, date_formated_created , %A_LoopFileTimeCreated%, dd.MM.yy | HH:mm
	FileGetTime, lastchanged , %A_LoopFileDir%\%A_LoopFileName%\SaveSlotData.NnT, M
	FormatTime, date_formated_lastchanged , %lastchanged%, dd.MM.yy | HH:mm

	LV_Add(, A_LoopFileName, date_formated_lastchanged, date_formated_created, backupNumber)	
}

LV_ModifyCol(3, "SortDesc")

return


; =================================================================
; Check for game process ==========================================
; =================================================================

gameProcessCheck:

WinGet, gamelocation_exe, ProcessPath, ahk_exe NNT.exe
SplitPath, gamelocation_exe ,, gamelocation

if (fileexist(gamelocation "\savegame\"))
{
	settimer,gameProcessCheck, off

	Loop, Files, %gamelocation%\savegame\* , D
	location_savegame := A_LoopFileFullPath
	iniwrite, %location_savegame%, %configlocation%, info, location_savegame
	Guicontrol, settingsGui:, edit_location_savegame, %location_savegame%
	Guicontrol, mainGui: enable, button_createBackup
}

return


; =================================================================
; Handle list event ===============================================
; =================================================================

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


; =================================================================
; Change filepaths ================================================
; =================================================================

changeLocation_savegame:

Gui, settingsGui:+OwnDialogs

dirwindowname := "Select savegame location"
FileSelectFolder, filechoose_savegame ,*%location_savegame%,, %dirwindowname%

if (ErrorLevel != 1)
{
	Guicontrol, settingsGui:, edit_location_savegame, %filechoose_savegame%
	iniwrite, %filechoose_savegame%, %configlocation%, info, location_savegame
	location_savegame := filechoose_savegame
	if (fileexist(location_savegame))
	Guicontrol, mainGui: enable, button_createBackup
}

return


changeLocation_backup:

Gui, settingsGui:+OwnDialogs

dirwindowname := "Select backup location"
FileSelectFolder, filechoose_backup ,*%location_backup%,, %dirwindowname%

if (ErrorLevel != 1)
{
	Guicontrol, settingsGui:, edit_location_backup, %filechoose_backup%
	iniwrite, %filechoose_backup%, %configlocation%, info, location_backup
	location_backup := filechoose_backup
	backupLocationChange := 1
}

return


; =================================================================
; Misc ============================================================
; =================================================================

refreshCurrentSavegameText()
{
	global location_savegame
	if (fileexist(location_savegame "\SaveSlotData.NnT"))
	{
		FileGetTime, lastchanged , %location_savegame%\SaveSlotData.NnT, M
		FormatTime, date_formated , %lastchanged%, dd.MM.yy | HH:mm
		Guicontrol, mainGui:, text_currentSave, %date_formated%
	}
}


open_savegameLocation:
if (fileexist(location_savegame))
run, %location_savegame%
return

changeCheckbox_playSound:
Gui, maingui: submit, nohide
iniwrite, %checkbox_playsound%, %configlocation%, settings, playSound
return


showSettings:

GuiControl, settingsGui: Focus, text_hotkey
Gui,Maingui: +disabled
WinGetPos , winX, winY,, %mainguiId%
settingsX := winX
settingsY := winY + 40
backupLocationChange := 0
Gui, settingsGui: show, w%settingsGuiW% h%settingsGuiH% x%settingsX% y%settingsY%, Settings
return


SettingsguiGuiClose:
Gui, settingsGui: submit, nohide
hotkey, %edit_hotkey%, createBackup_hotkey
iniwrite, %edit_hotkey%, %configlocation%, settings, hotkey_createBackup

backupNameStyle := edit_backupNameStyle
backupNameStyle := RegExReplace(edit_backupNameStyle, "\d")
GuiControl, settingsGui:, edit_backupNameStyle, %backupNameStyle%
iniwrite, %backupNameStyle%, %configlocation%, settings, backupNameStyle

Gui,Maingui: -disabled
Gui, Settingsgui: Hide

if (backupLocationChange = 1)
goto, refreshlist

return


mainguiguiclose:
exitapp
return


~^+f10::
ListVars
return