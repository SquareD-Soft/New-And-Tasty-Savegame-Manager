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

## Installation  

1. **Download the script or release**:  
   - **Recommended**: Download the precompiled `.exe` file from the [Releases page](#). This does not require any additional software.  
   - Alternatively: Download the `SavegameManager.ahk` file and place it in a dedicated folder.  
2. **Requirements (for the .ahk file)**:  
   - Install [AutoHotkey v1.1+](https://www.autohotkey.com/download/) if it is not already installed on your system.  
3. **Run the script**:  
   - Double-click the `SavegameManager.ahk` file to execute it.  
   - Alternatively, you can use the AutoHotkey compiler to convert the `.ahk` file into a standalone `.exe`.  

---

## Usage  

### Hotkeys  
By default, the following hotkeys are available:  
- **F9**: Create a new backup.  
  *(You can change this in the settings GUI.)*  

### Backup Creation  
- Backups can only be created once a valid savegame path is detected.
- If the savegame path is not set at startup, the program will automatically detect it once the game is started while the program is running.
- Once the savegame path is available, click "Create Backup" in the main GUI or use the configured hotkey to create a backup.
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

