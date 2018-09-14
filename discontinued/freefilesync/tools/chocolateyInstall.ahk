; This script will exit after 60 seconds
SetTimer, TimeOut, 60000

; License Agreement window
WinWait, Setup - FreeFileSync, DirEdit
WinGet, id, ID, Setup - FreeFileSync ahk_class TWizardForm, DirEdit
DetectHiddenText, Off

; Accept agreement button
ControlClick, TNewRadioButton1, ahk_id %id%
; Next button
ControlClick, TNewButton1, ahk_id %id%
sleep, 100

; Next button in Destination Location window
ControlClick, TNewButton3, ahk_id %id%
sleep, 100

; Next on components page
ControlClick, TNewButton3, ahk_id %id%
sleep, 100

; Next on animal picture page
ControlClick, TNewButton3, ahk_id %id%
sleep 1000

__Installing:
;Keep attempting to close window
While( WinExist("ahk_id" . id, "...") )
  sleep, 250

winget, ActiveControlList, ControlList, ahk_id %id%
Active := 0
Loop, Parse, ActiveControlList, `n
{
  ControlGet, CanSee, Visible ,, %A_LoopField%, ahk_id %id%
  ControlGet, CanWork, Enabled ,, %A_LoopField%, ahk_id %id%
  ControlGetText, RText, %A_LoopField%, ahk_id %id%
  ControlGetPos, X, Y, W, H, %A_LoopField%, ahk_id %id%
  If (CanSee and CanWork 
       and W != 0 and H != 0
       and InStr(A_LoopField,"button",false))
    Active += 1
}
if (Active <= 1 and WinExist("ahk_id" . id)) 
  goto __Installing

sleep, 250
ControlClick, TNewButton4, ahk_id %id%
ExitApp

TimeOut:
ExitApp 60
