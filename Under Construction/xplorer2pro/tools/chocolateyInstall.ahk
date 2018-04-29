DetectHiddenWindows, on
__Welcome:
; Welcome window
WinWait, xplorer² professional %1% bit Setup, Welcome
WinHide, xplorer² professional %1% bit Setup, Welcome
sleep 2000
; Next button
ControlClick, Button2, xplorer² professional %1% bit Setup, Welcome

__License:
; License Agreement window
WinWait, xplorer² professional %1% bit Setup, License Agreement, 1
if ErrorLevel {
  if WinExist(xplorer² professional %1% bit Setup, Welcome) {
    goto, __Welcome
  }
}
; Accept agreement button
ControlClick, Button4, xplorer² professional %1% bit Setup, License Agreement
; Next button
ControlClick, Button2, xplorer² professional %1% bit Setup, License Agreement

__Location:
; Destination Location window
WinWait, xplorer² professional %1% bit Setup, Choose Install Location, 1
if ErrorLevel {
  if WinExist(xplorer² professional %1% bit Setup, License Agreement) {
    goto, __License
  }
}
; Next button
ControlClick, Button2, xplorer² professional %1% bit Setup, Choose Install Location

__StartMenuIcons:
; Start Menu shortcuts window
WinWait, xplorer² professional %1% bit Setup, Choose Start Menu Folder, 1
if ErrorLevel {
  if WinExist(xplorer² professional %1% bit Setup, Choose Install Location) {
    goto, __Location
  }
}
; Next button
ControlClick, Button2, xplorer² professional %1% bit Setup, Choose Start Menu Folder

__AdditionalTasks:
; Additional install options window
WinWait, xplorer² professional %1% bit Setup, Choose Additional Tasks, 1
if ErrorLevel {
  if WinExist(xplorer² professional %1% bit Setup, Choose Start Menu Folder) {
    goto, __StartMenuIcons
  }
}
; create Desktop shortcut
controlGet, CheckVal, Checked,, Button5, xplorer² professional %1% bit Setup, Choose Additional Tasks
if ((CheckVal) ^ (InStr(A_Args[2], "D"))) {
  ControlClick, Button5, xplorer² professional %1% bit Setup, Choose Additional Tasks
}
; Modern skin
controlGet, CheckVal, Checked,, Button11, xplorer² professional %1% bit Setup, Choose Additional Tasks
if ((CheckVal) ^ (InStr(A_Args[2], "M"))) {
  ControlClick, Button11, xplorer² professional %1% bit Setup, Choose Additional Tasks
}
; Replace explorer
controlGet, CheckVal, Checked,, Button9, xplorer² professional %1% bit Setup, Choose Additional Tasks
if ((CheckVal) ^ (InStr(A_Args[2], "R"))) {
 ControlClick, Button9, xplorer² professional %1% bit Setup, Choose Additional Tasks
}
; for All users
controlGet, CheckVal, Checked,, Button13, xplorer² professional %1% bit Setup, Choose Additional Tasks 
if ((CheckVal) ^ (InStr(A_Args[2], "A"))) {
  ControlClick, Button13, xplorer² professional %1% bit Setup, Choose Additional Tasks
}
; add to Context menu
controlGet, CheckVal, Checked,, Button12, xplorer² professional %1% bit Setup, Choose Additional Tasks
if ((CheckVal) ^ (InStr(A_Args[2], "C"))) {
  ControlClick, Button12, xplorer² professional %1% bit Setup, Choose Additional Tasks
}
; Select Language
Control, ChooseString, %3%, ComboBox1 , xplorer² professional %1% bit Setup, Choose Additional Tasks

; Next button
ControlClick, Button2, xplorer² professional %1% bit Setup, Choose Additional Tasks

; Completed window
WinWait, xplorer² professional %1% bit Setup, Click Finish to close
; Run checkbox
ControlClick, Button4, xplorer² professional %1% bit Setup, Click Finish to close
; Show Readme checkbox
ControlClick, Button5, xplorer² professional %1% bit Setup, Click Finish to close
; Next button
ControlClick, Button2, xplorer² professional %1% bit Setup, Click Finish to close

WinShow, xplorer² professional %1% bit Setup
