DetectHiddenWindows, on
Dest = %1%

winWait, FastCopy Setup, Setup Mode
;WinHide, FastCopy Setup, Setup Mode

__Setup:
ControlFocus, Edit1, FastCopy Setup, Setup Mode
ControlClick, Extract only, FastCopy Setup, Setup Mode

__Extract:
WinWait, FastCopy, Select the location, 1
if ErrorLevel {
  goto, __Setup
}
ControlFocus, Edit1, FastCopy, Select the location
SendInput, ^a%Dest%
sleep, 100
ControlGetText, PathVal, Edit1, FastCopy, Select the location
if (PathVal <> Dest) {
  goto, __Extract
}
ControlClick, OK, FastCopy, Select the location
sleep, 1000
WinClose, %Dest%
