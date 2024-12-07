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

1. **Download**:  
   - Download the latest version, which includes both the `.exe` file and the `.ahk` script, and extract them to a folder.
2. **Running the `.exe`**:  
   - **Recommended**: Run the `.exe` file to run the program directly. No additional software required.
3. **Alternatively: Running the `.ahk` file**:  
   - If you prefer to run the script as an AutoHotkey file, you need to have [AutoHotkey v1.1+](https://www.autohotkey.com/download/) installed on your system.

---

## Usage  

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

### Hotkeys  
By default, the following hotkeys are available:  
- **F9**: Create a new backup.  
  *(You can change this in the settings GUI.)*  

### Settings  
- Access the settings via the **"Settings"** button in the main GUI.  
- Configure savegame/backup locations, hotkeys, and backup naming styles.  

---

## File Structure  
- **cfg/**: Contains the configuration file (`config.ini`).  
- **savegame backups/**: Default folder for storing backups.  

