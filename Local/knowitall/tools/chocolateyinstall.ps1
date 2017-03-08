$packageName = 'knowitall'

$ScriptDir = Split-Path $MyInvocation.MyCommand.Definition

start-process -NoNewWindow AutoHotKey $(Join-Path $ScriptDir 'chocolateyInstall.ahk')

$InstallArgs = @{
   PackageName    = $packageName
   url            = '\\Servername\sharename\KnowItAll\KnowItAllInstall_offline.exe'
   Checksum       = '53AD5FA6D870CE85837ABE27BFF9DB70'
   FileType       = 'exe'
   SilentArgs     = '/exenoui'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs




