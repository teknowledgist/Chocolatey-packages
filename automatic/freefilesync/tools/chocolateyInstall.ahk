; For now, there doesn't appear to be Open Candy in the installer
Run, %1%, , Min
winWait, Setup - FreeFileSync, License Agreement
ControlClick, I &accept the agreement, Setup - FreeFileSync, License Agreement
ControlClick, &Next, Setup - FreeFileSync, License Agreement
WinWait, Setup - FreeFileSync, Select Destination Location
ControlClick, &Next, Setup - FreeFileSync, Select Destination Location
WinWait, Setup - FreeFileSync, Select Components
ControlClick, &Next, Setup - FreeFileSync, Select Components
WinWait, Setup - FreeFileSync, Setup has finished installing
ControlClick, &Finish
