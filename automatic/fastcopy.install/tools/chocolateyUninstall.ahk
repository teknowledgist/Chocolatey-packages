DetectHiddenWindows, on

__Setup:
winWait, FastCopy Setup, Setup Mode
;WinHide, FastCopy Setup, Setup Mode

ControlClick, 2. Uninstall, FastCopy Setup, Setup Mode
ControlClick, Start, FastCopy Setup, Setup Mode

__UnInstall:
WinWait, UnInstall, Starting, 1
if ErrorLevel {
  goto, __Setup
}
ControlClick, OK, UnInstall, Starting

__Done:
WinWait, msg, completed, 3
if ErrorLevel {
  goto, __UnInstall
}
ControlClick, OK, msg, completed

; close the windows containing what the user is supposed to manually delete
WinWait, , %ProgramFiles%\FastCopy, 0
WinClose, , %ProgramFiles%\FastCopy
