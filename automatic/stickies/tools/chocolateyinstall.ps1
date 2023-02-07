$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove old-installer versions
[array]$key = Get-UninstallRegistryKey -SoftwareName 'stickies*'
if ($key.Count -eq 1) {
   Start-Process -FilePath $key.UninstallString -WindowStyle Hidden
   Remove-Item $key.PSPath -Recurse -Force
} 

# And any newer, "portable" installs 
$Previous = Get-ChildItem $FolderOfPackage -filter "v*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$Installer = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object -Property LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

$Before = Get-ChildItem $toolsDir
$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File           = $Installer
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '-extract'
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @packageArgs
Remove-Item $Installer -ea 0 -force

# Identify new files and move them to own directory
New-Item "$FolderOfPackage\v$env:ChocolateyPackageVersion" -ItemType Directory -Force
$Extracted = Compare-Object -ReferenceObject $before -DifferenceObject (Get-ChildItem $toolsDir) | 
                  Where-Object {$_.sideindicator -eq '=>'} | 
                  Select-Object -ExpandProperty InputObject | 
                  Select-Object -ExpandProperty FullName
foreach ($File in $Extracted) {
   $null = Move-Item $File "$FolderOfPackage\v$env:ChocolateyPackageVersion" -Force
}

# Create a Start Menu item for all users
$SCArgs = @{
   shortcutFilePath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Stickies.lnk"
   targetPath       = "$FolderOfPackage\v$env:ChocolateyPackageVersion\stickies.exe"
}
Install-ChocolateyShortcut @SCArgs 

# Ignore other included executables
$exes = Get-ChildItem "$FolderOfPackage\v$env:ChocolateyPackageVersion\" -filter *.exe -Exclude 'stickies.exe' -Recurse
foreach ($exe in $exes) {
   $null = New-Item "$($exe.fullname).ignore" -Type file -Force
}
