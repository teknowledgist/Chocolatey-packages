DetectHiddenWindows, on
__Welcome:
; Welcome window
WinWait, xplorer² professional %1% bit Uninstall, Uninstall Wizard
WinHide, xplorer² professional %1% bit Uninstall, Uninstall Wizard
; Next button
ControlClick, Button2, xplorer² professional %1% bit Uninstall, Uninstall Wizard

__Uninstall:
; Uninstall location window
WinWait, xplorer² professional %1% bit Uninstall, Uninstalling from, 1
if ErrorLevel {
  if WinExist(xplorer² professional %1% bit Uninstall, Uninstall Wizard) {
    goto, __Welcome
  }
}
; Uninstall button
ControlClick, Button2, xplorer² professional %1% bit Uninstall, Uninstalling from

__RegSettings:
; Remove registry settings popup
WinWait, xplorer² professional %1% bit Uninstall, remove xplorer² registry settings?, 1
if ErrorLevel {
  if WinExist(xplorer² professional %1% bit Uninstall, Uninstalling from) {
    goto, __Uninstall
  }
}
; Yes or No button based on switch
ControlClick, Button%2%, xplorer² professional %1% bit Uninstall, remove xplorer² registry settings?

; Completed window
WinWait, xplorer² professional %1% bit Uninstall, Click Finish to close
; Finish button
ControlClick, Button2, xplorer² professional %1% bit Uninstall, Click Finish to close

WinShow, xplorer² professional %1% bit Uninstall
