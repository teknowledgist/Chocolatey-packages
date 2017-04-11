DetectHiddenWindows, On
SetTitleMatchMode, RegEx

Run, %1%, , Hide

winWait, Bluebeam Vu.*InstallShield
ControlClick, &Next, Bluebeam Vu.*InstallShield
ControlClick, I &accept, Bluebeam Vu.*InstallShield
ControlClick, &Next, Bluebeam Vu.*InstallShield

ControlGet, Default, Checked,, default PDF viewer, Bluebeam Vu.*InstallShield
if (%Default% = 1) {
   ControlClick, default PDF, Bluebeam Vu.*InstallShield
}
ControlClick, &Install, Bluebeam Vu.*InstallShield

winWait, Bluebeam Vu.*InstallShield, Vu has been successfully installed
ControlClick, &Finish, Bluebeam Vu.*InstallShield
