$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageFolder -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ToolsDir   = Join-Path $PackageFolder 'tools'
$ZipFile = Get-ChildItem $ToolsDir -filter '*.zip' | Sort-Object LastWriteTime | Select-Object -Last 1

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile.FullName
   Destination  = (Join-path $PackageFolder ($env:ChocolateyPackageName + '_' + $env:ChocolateyPackageVersion))
}

Get-ChocolateyUnzip @InstallArgs

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'ToDoList.lnk'
$targetPath = Get-ChildItem $InstallArgs.Destination -filter 'ToDoList.exe' -recurse

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath.FullName

$null = New-Item -Path "$($targetPath.FullName).gui" -ItemType File -Force

Get-ChildItem $targetPath.DirectoryName -filter '*.exe' -recurse | 
               Where-Object {$_.name -ne $targetPath.name} |
               ForEach-Object {
                     $null = New-Item -Path "$($_.fullname).ignore" -ItemType File -Force
               }

