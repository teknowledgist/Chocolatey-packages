$ErrorActionPreference = 'Stop'

if (-not (Get-ProcessorBits -compare 64)) {
   Throw "$env:ChocolateyPackageName only runs on 64-bit systems."
}

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$EXE = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 1

# Remove old versions
Get-ChildItem $toolsDir -Filter '*.exe' | 
      Where-Object {$_ -ne $EXE} | 
      ForEach-Object { Remove-Item $_.fullname }

