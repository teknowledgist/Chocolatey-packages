Import-Module Chocolatey-AU
Import-Module -Name Evergreen
# Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"


function global:au_GetLatest {
   $Meta = Get-EvergreenApp Zotero 

   $x86 = $Meta | Where-Object { $_.architecture -eq 'x86' -and $_.type -eq 'exe' }
   $x64 = $Meta | Where-Object { $_.architecture -eq 'x64' -and $_.type -eq 'exe' }
   $ARM64 = $Meta | Where-Object { $_.architecture -eq 'ARM64' -and $_.type -eq 'exe' }

   return @{ 
      Version       = $x64.Version
      URL32         = $x86.URI
      URL64         = $x64.URI
      URLARM64      = $ARM64.URI
   }

}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^[$]URL_x86 =).*" = "`${1} '$($Latest.URL32)'"
      "(?i)(^[$]SHA_x86 =).*" = "`${1} '$($Latest.Checksum32)'"
      "(?i)(^[$]URL_x64 =).*" = "`${1} '$($Latest.URL64)'"
      "(?i)(^[$]SHA_x64 =).*" = "`${1} '$($Latest.Checksum64)'"
      "(?i)(^[$]URL_ARM64 =).*" = "`${1} '$($Latest.URLARM64)'"
      "(?i)(^[$]SHA_ARM64 =).*" = "`${1} '$($Latest.ChecksumARM64)'"
    }
  }
}

function global:au_BeforeUpdate() { 
   # Need to trick AU to get hash of ARM64 file. This will download the 32-bit installer twice.
   $TempURL64 = $Latest.URL64
   $TempSha = $Latest.Checksum64
   $Latest.URL64 = $Latest.URLARM64
   $Latest.Checksum64 = $Latest.ChecksumARM64

   Get-RemoteFiles -NoSuffix

   $Latest.ChecksumARM64 = $Latest.Checksum64
   $Latest.URL64 = $TempURL64
   $Latest.Checksum64 = $TempSha

   Get-RemoteFiles -NoSuffix

   # This isn't an embedded package, so delete all the installers.
   $toolsDir = Resolve-Path tools
   $Installers = Get-ChildItem $toolsDir -filter '*.exe'
   Foreach ($exe in $Installers) { Remove-Item $exe.FullName }
}


Update-Package -ChecksumFor all
