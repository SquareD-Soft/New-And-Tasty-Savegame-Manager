#New and Tasty Savegame Manager
A simple savegame manager for Oddworld: New 'n' Tasty. This tool allows you to easily create backups of your savegames, manage them, and restore previous save states.

Features
Automatic Savegame Detection: Finds the savegame folder automatically for the Steam version of the game.
Backup Creation: Create organized backups with a custom naming style.
Backup Restoration: Easily restore savegames from the list of backups.
User Configurable:
Define custom hotkeys for creating backups.
Enable/disable sound notifications.
Customize backup folder and savegame locations.
Requirements
Autohotkey v1.1+ (Windows only)
Installation
Download the script: Clone this repository or download the SavegameManager.ahk file.
Run the script:
Double-click the SavegameManager.ahk file to run it.
Alternatively, compile the script to an .exe using AutoHotkey's compiler for standalone usage.
Configure your settings:
When you run the script for the first time, it will create a configuration file (cfg/config.ini).
You can modify this file or adjust settings in the GUI.
Usage
Hotkeys
By default, the following hotkeys are available:

F9: Create a new backup.
(You can change this in the settings GUI.)
Backup Creation
Click "Create Backup" in the main GUI or use the configured hotkey.
The backup will be saved in the specified backup location.
Backup Restoration
Select a backup from the list in the GUI.
Click "Load Backup".
Confirm the action in the popup window.
The savegame will be replaced with the selected backup.
Settings
Access the settings via the "Settings" button in the main GUI.
Configure savegame/backup locations, hotkeys, and backup naming styles.
