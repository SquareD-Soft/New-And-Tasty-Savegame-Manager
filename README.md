# New and Tasty Savegame Manager  

A simple **savegame manager** for *Oddworld: New 'n' Tasty*. This tool allows you to easily create backups of your savegames, manage them, and restore previous save states.  



---

## Features    
- **Backup Creation**: Create organized backups with a custom naming style.  
- **Backup Restoration**: Easily restore savegames from the list of backups.  
- **User Configurable**:  
  - Define custom hotkeys for creating backups.  
  - Enable/disable sound notifications.  
- **Backup Organization**: For each backup, a new folder is created that includes the save slot file and all related save slots.

---

## Requirements  
- [Autohotkey v1.1](https://www.autohotkey.com/) (Windows only). This is **required** to run the `.ahk` script.  

---

## Installation  

1. **Download the script or release**:  
   - Download the files from the [Releases page](https://github.com/SquareD-Soft/New-And-Tasty-Savegame-Manager/releases).
2. **Requirements (for the .ahk file)**:  
   - Install [AutoHotkey v1.1](https://www.autohotkey.com/) if it is not already installed on your system.  
3. **Run the script**:  
   - Simply run the `.ahk` file to execute it.  
   - Alternatively, you can compile the `.ahk` script into a standalone `.exe` using AutoHotkey.

---

## Usage  

### Important Notes  
- **Game must be closed** when restoring backups.
- **Hotkeys** are only active when the game is active. They can be disabled in the settings if not needed.
  
### Backup Creation  
- Backups can only be created once a valid savegame and backup path is detected.
- If the savegame path is not set at startup, the program will automatically detect it once the game is started while the program is running.
- Once the savegame and backup path is available, click "Create Backup" in the main GUI or use the configured hotkey to create a backup.
- A new folder will be created for each backup, containing the save slot file and all save slots.

### Backup Restoration  
1. Select a backup from the list in the GUI.  
2. Click **"Load Backup"**.  
3. Confirm the action in the popup window.  
4. The savegame will be replaced with the selected backup.

### Hotkeys  
By default, the following hotkeys are available:  
- **F3**: Create a new backup.  
  *(You can change this in the settings GUI.)*  
- The hotkey can be **disabled** in the options if it is not needed.

### Settings  
- Access the settings via the **"Settings"** button in the main GUI.  
- Configure savegame/backup locations, hotkeys, and backup naming styles.  

---

## File Structure  
- **cfg/**: Contains the configuration file (`config.ini`).  
- **savegame backups/**: Default folder for storing backups.  
