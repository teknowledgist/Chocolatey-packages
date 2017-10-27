$ErrorActionPreference = 'Stop'  # stop on all errors

$ToolsDir   = Join-Path $env:ChocolateyPackageFolder 'tools'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter 'FastCopy*' | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

if (Get-OSArchitectureWidth -eq '64') {
   $x64 = '_x64'
}

$FolderName = "FastCopy$x64 $env:ChocolateyPackageVersion"

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*$x64.zip").FullName
   Destination  = (Join-path $env:ChocolateyPackageFolder $FolderName)
}

Get-ChocolateyUnzip @InstallArgs

# Prevent the installer from being on the path
$installFile = Join-Path $InstallArgs.Destination "setup.exe"
if (Test-Path $installFile) {
  New-Item "$installFile.ignore" -type file -force | Out-Null
}

