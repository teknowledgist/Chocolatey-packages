DetectHiddenWindows, On
SetTitleMatchMode, RegEx

winWait, Bluebeam Vu.*InstallShield
ControlClick, &Next, Bluebeam Vu.*InstallShield
winWait, Bluebeam Vu.*InstallShield, license agreement
ControlClick, I &accept, Bluebeam Vu.*InstallShield
ControlClick, &Next, Bluebeam Vu.*InstallShield

winWait, Bluebeam Vu.*InstallShield, installation options
ControlGet, Default, Checked,, default PDF viewer, Bluebeam Vu.*InstallShield
if (%Default% = 1) {
   ControlClick, default PDF, Bluebeam Vu.*InstallShield
}
ControlClick, &Install, Bluebeam Vu.*InstallShield

winWait, Bluebeam Vu.*InstallShield, Vu has been successfully installed
ControlClick, &Finish, Bluebeam Vu.*InstallShield
