; This script will exit after 10 seconds
SetTimer(ForceExitAHK, 10000)

winWait("xplorer² lite 32 bit Uninstall", "Do you want to remove")
sleep 100
ControlClick("&Yes", "xplorer² lite 32 bit Uninstall")

ExitApp

ForceExitAHK:
{
   SetTimer(ForceExitAHK, Delete)
   ExitApp 10
}
