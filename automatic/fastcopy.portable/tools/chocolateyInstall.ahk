; This script will exit after 10 seconds
SetTimer, TimeOut, 10000

DetectHiddenWindows, on
Dest = %1%

winWait, FastCopy Setup, Setup Mode
WinHide, FastCopy Setup, Setup Mode

__Setup:
ControlClick, Extract only, FastCopy Setup, Setup Mode

__Extract:
WinWait, FastCopy, Select the location to extract, 1
if ErrorLevel {
  goto, __Setup
}
WinHide, FastCopy, Select the location to extract
sleep, 500
__Fill:
ControlSetText, Edit1, %Dest%, FastCopy, Select the location to extract
sleep, 500
ControlGetText, PathVal, Edit1, FastCopy, Select the location to extract
if (PathVal <> Dest) {
  goto, __Fill
}
ControlClick, OK, FastCopy, Select the location to extract
sleep, 1000
WinClose, %Dest%
ExitApp

TimeOut:
ExitApp 10
