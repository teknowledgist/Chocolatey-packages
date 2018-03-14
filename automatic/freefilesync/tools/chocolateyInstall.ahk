Run, %1%, , Min

WinWait, Setup - FreeFileSync
; Accept agreement
ControlClick, TNewRadioButton1, Setup - FreeFileSync
; Next
ControlClick, TNewButton1, Setup - FreeFileSync

DetectHiddenText, Off
WinWait, Setup - FreeFileSync, DirEdit
; Next
ControlClick, TNewButton3, Setup - FreeFileSync

WinWait, Setup - FreeFileSync
; Next
ControlClick, TNewButton3, Setup - FreeFileSync

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

WinWait, Setup - FreeFileSync, FreeFileSync, , , ...
; Finish
ControlClick, TNewButton4, Setup - FreeFileSync
