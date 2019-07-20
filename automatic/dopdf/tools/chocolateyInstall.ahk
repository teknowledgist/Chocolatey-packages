; This script will exit after 120 seconds
SetTimer, TimeOut, 120000

DetectHiddenWindows, on
__First:
; First window
WinWait, doPDF installer ahk_exe dopdf-full.exe

WinActivate, doPDF installer ahk_exe dopdf-full.exe
;WinHide, ahk_id %appid%
; Telemetry checkbox
Send {Click 333, 518}
; Install button
Send {Click 250, 400}


PixelGetColor, BGcolor, 1, 1

__Wait:
sleep, 250
;MouseGetPos, xpos, ypos 
If (WinExist(doPDF ahk_class #32770)) {
   ControlClick, OK, doPDF ahk_class #32770
}
WinActivate, doPDF installer ahk_exe dopdf-full.exe
MouseMove, 414, 414

PixelGetColor, ButtonColor, 414, 414
If (WinExist(doPDF installer ahk_exe dopdf-full.exe) 
    AND (ButtonColor != "0x44a24f")) {
;  MouseMove, xpos, ypos
  goto, __Wait
}

If (ButtonColor = "0x44a24f") {
  Send {Click 470,515}
}

ExitApp

TimeOut:
ExitApp 120
