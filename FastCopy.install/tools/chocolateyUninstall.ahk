; Uninstall is an option in the installer
; First, remove shell extensions
Run, c:\Program Files\FastCopy\FastCopy.exe
WinWait, FastCopy ver
WinMenuSelectItem, FastCopy ver, ,Option,Extensions,Shell Extension
WinWait, Shell Extension Settings
ControlClick, Uninstall, Shell Extension Settings
WinClose Shell Extension Settings
WinClose FastCopy ver

; Second, run the uninstall
Run, c:\Program Files\FastCoy\setup.exe
WinWait, FastCopy Setup
ControlSend, 2. Uninstall, {space},FastCopy Setup
ControlSend, Start, {space},FastCopy Setup
WinWait, UnInstall,Starting
ControlSend, OK, {space},UnInstall
WinWait, msg,Uninstallation
ControlSend, OK, {space},msg
