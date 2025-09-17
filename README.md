# WU-Disable.ps1
> **Author:** Justus Hofmann  
> **Copyright © 2025 Justus Hofmann**

---

## Description
This PowerShell script enables or disables Windows Updates by renaming registry keys for update-related services. Useful for administrators who want to quickly block or restore Windows Update functionality.

---

## Important Caveats !!
- System File Check (SFC) fails.
- wsl.exe --install fails with 0x80070005.
- DISM.exe /Online /Cleanup-Image /Restorehealth fails.
- Anything related to Microsoft Store fails with 0x8a15005e. This is true even if you are using for example WingetUI/UnigetUI.

---

## Important Notes 
- Run the script as Administrator.
- Disabling updates may expose your system to risks. Use at your own risk.
- After enabling updates, restart your computer (do not shut down) for changes to take effect.

---

## Usage
1. Open PowerShell as Administrator.
2. Navigate to the folder containing the script.
3. To disable updates, run: .\WU-Disable.ps1 -Disable
4. To enable updates, run: .\WU-Disable.ps1 -Enable

---

## What it does
- Disabling backs up the relevant registry section and renames update-related services to block updates.
- Enabling restores original service names and prompts for a restart.

---

## Credit
This was inspired by [Henke's](https://superuser.com/users/1102737/henke) post on this question: <https://superuser.com/questions/946957/stopping-all-automatic-updates-windows-10>

---

## License
No warranty or liability. Use at your own risk.
