$ErrorActionPreference = 'Stop'

# Remove possible previous install
[array]$key = Get-UninstallRegistryKey -SoftwareName 'LilyPond*'
if ($key.Count -eq 1) {
   $RemoveProc = Start-Process -FilePath $key[0].UninstallString -ArgumentList '/S' -PassThru
   $updateId = $RemoveProc.Id
   Write-Debug 'Uninstalling old version of LilyPond.'
   Write-Debug "Uninstall Process ID:`t$updateId"
   $RemoveProc.WaitForExit()
} elseif ($key.Count -gt 1) {
   Write-Warning 'Multiple, previous installs found!  This portable package will finish, but no previous installs will be removed.'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous, unzipped "installs"
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}
# Remove previous installers
$Previous = Get-ChildItem $FolderOfPackage -filter '*.exe'
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = Get-ChildItem $toolsDir -filter '*.zip' |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty fullname -Last 1

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile
   Destination    = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

Remove-Item $ZipFile -Force

$EXEs = Get-ChildItem $UnZipArgs.Destination -Filter '*.exe' -Recurse | 
         Select-Object -ExpandProperty fullname

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\LilyPond.lnk'
   TargetPath       = $EXEs | Where-Object {$_ -like '*lilypond.exe'}
}
Install-ChocolateyShortcut @ShortcutArgs

foreach ($exe in $exes) {
   if ($exe -notlike '*lilypond.exe') {
      $null = New-Item "$exe.ignore" -Type file -Force
   }
}
