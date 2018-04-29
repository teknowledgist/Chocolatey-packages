msgbox %1%

__Welcome:
; Welcome window
WinWait, xplorer² professional %1% bit Setup, Welcome
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
