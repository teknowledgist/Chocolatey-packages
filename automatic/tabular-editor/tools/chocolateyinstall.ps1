$ErrorActionPreference = 'Stop'

$Installer = Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.msi'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   File           = $Installer.FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs

# No start icon and no path in registry
If (Test-Path "$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log") {
   $Log = Get-Content "$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log"
   $null = $Log | Where-Object {$_ -match '^Property.*TARGETDIR = (.*)$'}
   
   $EXE = (Get-ChildItem $Matches[1] -filter *exe).fullname
   $Linkname = "Tabular Editor.lnk"
   $StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

   $ShortcutArgs = @{
      ShortcutFilePath = Join-Path $StartPrograms $Linkname
      TargetPath = $EXE
   }

   Install-ChocolateyShortcut @ShortcutArgs
}
