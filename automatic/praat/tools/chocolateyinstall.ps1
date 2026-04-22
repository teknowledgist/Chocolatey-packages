$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir
$BitLevel = Get-ProcessorBits

# Remove old versions
$null = Get-ChildItem $FolderOfPackage -Filter *.exe | Remove-Item -Force

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   # This is required until Chocolatey-AU "Get-RemoteFiles" also gets ARM64 files.
   $DLArgs = @{
      packageName         = $env:ChocolateyPackageName
      URL64bit            = 'https://github.com/praat/praat.github.io/releases/download/v6.4.64/praat6464_win-arm64.zip'
      FileFullPath        = "$toolsDir\Praat_ARM64.zip"
      Checksum64          = '305cb74f638953c9fc828e1f1e70f3a4adc18ce7edb282d5e9e3d3baa1e69f87'
      GetOriginalFileName = $true
   }
   $null = Get-ChocolateyWebFile @DLArgs

   $LookFor = 'arm64'
} elseif ($Bitlevel -eq '64') { $LookFor = 'intel64' }
else {$LookFor = 'intel32'}

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Where-Object {$_.basename -match "$LookFor`$"} | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $FolderOfPackage

$Linkname = (Get-Culture).textinfo.totitlecase($env:ChocolateyPackageName) + '.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname
$targetPath = (Get-ChildItem $FolderOfPackage -filter "*.exe").fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

$exes = Get-ChildItem $FolderOfPackage -filter *.exe |Select-Object -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.gui" -Type file -Force
}

Get-ChildItem $toolsDir -filter '*.zip' | ForEach-Object {Remove-Item $_.fullname -force}
