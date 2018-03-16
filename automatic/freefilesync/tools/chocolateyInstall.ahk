; License Agreement window
WinWait, Setup - FreeFileSync, License Agreement
; Accept agreement button
ControlClick, TNewRadioButton1, Setup - FreeFileSync, License Agreement
; Next button
ControlClick, TNewButton1, Setup - FreeFileSync, License Agreement

; Destination Location window
DetectHiddenText, Off
WinWait, Setup - FreeFileSync, Select Destination Location
; Next button
ControlClick, TNewButton3, Setup - FreeFileSync, Select Destination Location

; Components window
WinWait, Setup - FreeFileSync, Select Components
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
        ; Next
        ControlClick, TNewButton3, Setup - FreeFileSync
        WinWait, Setup - FreeFileSync, ...
    }
}

; Completed window
WinWait, Setup - FreeFileSync, Click Finish to exit
; Finish button
ControlClick, TNewButton4, Setup - FreeFileSync, Click Finish to exit