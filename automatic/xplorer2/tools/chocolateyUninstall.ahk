; This script will exit after 10 seconds
SetTimer(TimeOut, 10000)

winWait("xplorer² lite 32 bit Uninstall", "Do you want to remove")
sleep 100
ControlClick("&Yes", "xplorer² lite 32 bit Uninstall")

ExitApp

TimeOut()
{
   ExitApp 10
}
