$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir
$BitLevel = Get-ProcessorBits

# Remove old versions
$null = Get-ChildItem $FolderOfPackage -Filter *.exe | Remove-Item -Force

$ARM64url = 'https://github.com/praat/praat.github.io/releases/download/v6.6.30/praat6630_win-arm64.zip'
$ARM64sha = 'ab74942fbf569a4df1c02fb0a384bfc2ed7009cf80dc87ea05f2e56515ad73c9'
$X64v1url = 'https://github.com/praat/praat.github.io/releases/download/v6.6.30/praat6630_win-x64v1.zip'
$X64v1sha = '0720c28260eff630d537452759a555a088313642b19db0b297f5109d8aaf6f0a'

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ($Features.'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   # This is required until Chocolatey-AU "Get-RemoteFiles" also gets ARM64 files.
   $DLArgs = @{
      packageName         = $env:ChocolateyPackageName
      URL64bit            = $ARM64url
      FileFullPath        = "$toolsDir\Praat_ARM64.zip"
      Checksum64          = $ARM64sha
      GetOriginalFileName = $true
   }
   $null = Get-ChocolateyWebFile @DLArgs

   $LookFor = 'arm64'
} elseif ($BitLevel -eq '32') {$LookFor = 'intel32'}
elseif (-not $Features.'PF_AVX2_INSTRUCTIONS_AVAILABLE') {
   # Based on https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels
   #   missing AVX2 is a reasonable substitute for being a x86-64-v1 processor.
   Write-Verbose 'x64_v1 processor found.  Downloading X64_v1 build.'
   $DLArgs = @{
      packageName         = $env:ChocolateyPackageName
      URL64bit            = $X64v1url
      FileFullPath        = "$toolsDir\Praat_x64v1.zip"
      Checksum64          = $X64v1sha
      GetOriginalFileName = $true
   }
   $null = Get-ChocolateyWebFile @DLArgs

   $LookFor = 'x64v1'
}
else { 
   # Almost all production systems will benefit from the v3 architecture build 
   #    See: https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels
   $LookFor = 'x64v3' 
}

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
