; This script will exit after 15 seconds
SetTimer, TimeOut, 15000

DetectHiddenWindows, on

winWait, FastCopy Setup, Setup Mode
WinHide, FastCopy Setup, Setup Mode

__Setup:
sleep, 100
ControlSetText, Edit1, %ProgramFiles%\FastCopy, FastCopy Setup, Setup Mode
sleep, 200
ControlGetText, PathVal, Edit1, FastCopy Setup, Setup Mode
if (PathVal <> ProgramFiles . "\FastCopy") {
  goto, __Setup
}
ControlClick, Start, FastCopy Setup, Setup Mode

__Install:
WinWait, Install, Starting, 1
if ErrorLevel {
  goto, __Setup
}
WinHide, Install, Starting
ControlClick, OK, Install, Starting

__Done:
WinWait, Install, The setup was completed, 3
if ErrorLevel {
  goto, __Install
}
WinHide, Install, The setup was completed
ControlClick, Launch, Install, The setup was completed

; Next, enable shell extensions
WinWait, FastCopy ver, DestDir, 1
if ErrorLevel {
  goto, __Done
}
WinHide, FastCopy ver, DestDir
__Launch:
WinMenuSelectItem, FastCopy ver, , Option, Main Settings
WinWait, Main Settings, Default parameters, 1
if ErrorLevel {
  goto, __Launch
}
WinHide, Main Settings, Default parameters
Control, ChooseString, Shell Extension, ListBox1 , Main Settings
SetTitleMatchMode, RegEx
ControlGet, CheckVal, Checked,, ^Enable$, ^Main Settings$, For all users
if (!(CheckVal)) {
  ControlClick, ^Enable$, ^Main Settings$, For all users
}
SetTitleMatchMode, 1
ControlClick, OK, Main Settings
__Close:
sleep, 100
WinClose FastCopy ver
if WinExist(FastCopy ver, Execute) {
  goto, __Close
}
ExitApp

TimeOut:
ExitApp 10
