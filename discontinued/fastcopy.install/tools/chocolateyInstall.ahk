; This script will exit after 10 seconds
SetTimer, TimeOut, 10000

WinWait, ahk_exe FastCopy.exe, DestDir
WinGet, appid, ID, ahk_exe FastCopy.exe, DestDir
WinGetClass, FCclass, ahk_id %appid%
__MenuSelect:
WinMenuSelectItem, ahk_id %appid%, , Option, Main Settings
WinWait, Main Settings ahk_class %FCclass%,, 1
if ErrorLevel {
  goto, __MenuSelect
}
WinGet, setid, ID, Main Settings ahk_class %FCclass%
__Shell:
Control, ChooseString, Shell Extension, ListBox1 , ahk_id %setid%
WinWait, ahk_id %setid%, For all users, 1
if ErrorLevel {
  goto, __Shell
}
SetTitleMatchMode RegEx
ControlGet, CheckVal, Checked,, ^Enable$, ahk_id %setid%, for all users
if (!(CheckVal)) {
  ControlClick, ^Enable$, ahk_id %setid%, for all users
}
SetTitleMatchMode 1
__OK:
ControlClick, OK, ahk_id %setid%
if WinExist("ahk_id" . setid) {
  goto, __OK
}
__Close:
sleep, 100
WinClose FastCopy ver
if WinExist("ahk_id" . appid) {
  goto, __Close
}
ExitApp

TimeOut:
ExitApp 10