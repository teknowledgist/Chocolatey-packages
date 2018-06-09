DetectHiddenWindows, on

winWait, FastCopy Setup, Setup Mode
;WinHide, FastCopy Setup, Setup Mode

__Setup:
ControlFocus, Edit1, FastCopy Setup, Setup Mode
SendInput, ^a%ProgramFiles%\FastCopy
sleep, 100
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
ControlClick, OK, Install, Starting

__Done:
WinWait, Install, The setup was completed, 3
if ErrorLevel {
  goto, __Install
}
ControlClick, Launch, Install, The setup was completed

; Next, enable shell extensions
WinWait, FastCopy ver, DestDir, 1
if ErrorLevel {
  goto, __Done
}
__Launch:
WinMenuSelectItem, FastCopy ver, ,Option,Main Settings
WinWait, Main Settings, Default parameters, 1
if ErrorLevel {
  goto, __Launch
}
Control, ChooseString, Shell Extension, ListBox1 , Main Settings
ControlGet, CheckVal, Checked,, Enabled, Shell Extension, for all users
if (!(CheckVal)) {
  ControlClick, Button64, Main Settings, for all users
}
ControlClick, OK, Main Settings
__Close:
sleep, 100
WinClose FastCopy ver
if WinExist(FastCopy ver, Execute) {
  goto, __Close
}
