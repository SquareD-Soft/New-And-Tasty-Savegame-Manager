# New and Tasty Savegame Manager  

A simple **savegame manager** for *Oddworld: New 'n' Tasty*. This tool allows you to easily create backups of your savegames, manage them, and restore previous save states.  

---

## Features  
- **Automatic Savegame Detection**: Finds the savegame folder automatically for the Steam version of the game.  
- **Backup Creation**: Create organized backups with a custom naming style.  
- **Backup Restoration**: Easily restore savegames from the list of backups.  
- **User Configurable**:  
  - Define custom hotkeys for creating backups.  
  - Enable/disable sound notifications.  
  - Customize backup folder and savegame locations.  

---

## Requirements  
- [Autohotkey v1.1+](https://www.autohotkey.com/download/) (Windows only)  

---

## Installation  
1. **Download the script**: Clone this repository or download the `SavegameManager.ahk` file.  
2. **Run the script**:  
   - Double-click the `SavegameManager.ahk` file to run it.  
   - Alternatively, compile the script to an `.exe` using AutoHotkey's compiler for standalone usage.  
3. **Configure your settings**:  
   - When you run the script for the first time, it will create a configuration file (`cfg/config.ini`).  
   - You can modify this file or adjust settings in the GUI.  

---

## Usage  

### Hotkeys  
By default, the following hotkeys are available:  
- **F9**: Create a new backup.  
  *(You can change this in the settings GUI.)*  

### Backup Creation  
- Click **"Create Backup"** in the main GUI or use the configured hotkey.  
- The backup will be saved in the specified backup location.  

### Backup Restoration  
1. Select a backup from the list in the GUI.  
2. Click **"Load Backup"**.  
3. Confirm the action in the popup window.  
4. The savegame will be replaced with the selected backup.  

### Settings  
- Access the settings via the **"Settings"** button in the main GUI.  
- Configure savegame/backup locations, hotkeys, and backup naming styles.  

---

## File Structure  
- **cfg/**: Contains the configuration file (`config.ini`).  
- **save backups/**: Default folder for storing backups.  

---

## Example Configuration (`cfg/config.ini`)  

```ini
[info]
location_savegame=C:\Path\To\Savegame\Folder
location_backup=C:\Path\To\Backup\Folder

[settings]
backupNameStyle=NNTSaveBackup
hotkey_createBackup=F9
playSound=1
