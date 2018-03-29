__License:
; License Agreement window
WinWait, Setup - FreeFileSync, License Agreement
; Accept agreement button
ControlClick, TNewRadioButton1, Setup - FreeFileSync, License Agreement
; Next button
ControlClick, TNewButton1, Setup - FreeFileSync, License Agreement

DetectHiddenText, Off

__Location:
; Destination Location window
WinWait, Setup - FreeFileSync, Select Destination Location, 2
if ErrorLevel {
    if WinExist(Setup - FreeFileSync, License Agreement) {
      goto, __License
    }
}
; Next button
ControlClick, TNewButton3, Setup - FreeFileSync, Select Destination Location

__Components:
; Components window
WinWait, Setup - FreeFileSync, Select Components, 2
if ErrorLevel {
    if WinExist(Setup - FreeFileSync, Select Destination Location) {
      goto, __Location
    }
}
; Next button
ControlClick, TNewButton3, Setup - FreeFileSync, Select Components

; Wait 3 seconds for installation window
WinWait, Setup - FreeFileSync, ..., 3
; if additional software is trying to be installed, show dialog
; this panel will only show if the installation is run slowly enough
; so we shouldn't get it, but better safe than sorry.
if ErrorLevel {
  WinRestore, Setup - FreeFileSync, Install Additional Software
  MsgBox, 0x131, FreeFileSync is trying to install additional software,
  ( LTrim
      Please deselect unwanted software and then press "OK" in this dialog.
      Press "Cancel" if you want to finish the setup manually.
  )
  IfMsgBox, Cancel
  {
    Exit
  } else {
    ; Next button
    ControlClick, TNewButton3, Setup - FreeFileSync
  }
}

__Completed:
; Completed window
WinWait, Setup - FreeFileSync, Click Finish to exit, 15
if ErrorLevel {
    if WinExist(Setup - FreeFileSync, Select Components) {
      goto, __Components
    }
}
while WinExist(Setup - FreeFileSync, Click Finish to exit) {
  ; Finish button
  ControlClick, TNewButton4, Setup - FreeFileSync, Click Finish to exit
}

