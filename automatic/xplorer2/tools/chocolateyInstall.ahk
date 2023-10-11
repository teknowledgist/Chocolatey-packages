; This script will exit after 10 seconds
SetTimer ForceExitAHK, 10000

winWait "xplorer² lite 32 bit Setup", "ONLY for non-profit use"
sleep 100
ControlClick "OK", "xplorer² lite 32 bit Setup"

ExitApp

ForceExitAHK()
{
   SetTimer ForceExitAHK, 0
   ExitApp 10
}