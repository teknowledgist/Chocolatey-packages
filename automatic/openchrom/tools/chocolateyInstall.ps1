$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipArgs = @{
   PackageName   = $env:ChocolateyPackageName
   url           = 'https://sourceforge.net/projects/openchrom/files//REL-1.3.0/openchrom_win32.win32.x86_64_1.3.0.zip'
   checksum      = '0a84b9c0101c9db90c5672efa6de015d1a6a751d0b3822a92d3797a4df6994d3'
   ChecksumType  = 'sha256'
   UnzipLocation = Join-Path (Split-Path $toolsDir) "$env:ChocolateyPackageName$env:ChocolateyPackageVersion"
}

Install-ChocolateyZipPackage @ZipArgs

$exes = Get-ChildItem $ZipArgs.UnzipLocation | 
            Where-Object {$_.psiscontainer} | 
            ForEach-Object {Get-ChildItem $_.fullname -filter "*.exe" -Recurse}

foreach ($exe in $exes) {
   New-Item "$($exe.fullname).ignore" -Type file -Force | Out-Null
}

$GUI = (Get-ChildItem $ZipArgs.UnzipLocation -filter "$env:ChocolateyPackageName.exe").fullname
New-Item "$GUI.gui" -Type file -Force | Out-Null

$Linkname = "OpenChrom v$env:ChocolateyPackageVersion.lnk"
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms $Linkname
   TargetPath = $GUI
   IconLocation = Join-Path $toolsDir 'openchrom_icon.ico'
}

Install-ChocolateyShortcut @ShortcutArgs
