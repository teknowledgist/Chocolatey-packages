import-module chocolatey-au

function global:au_GetLatest {
   $Manifest = 'https://download.sassafras.com/software/release/img-manifest.json'
   $KSPdata = Invoke-RestMethod $Manifest

   return @{ 
      Version    = $KSPdata.version
      URL        = 'https://download.sassafras.com/software/release/current/Installers/Windows/Client/ksp-client-i386.exe'
      URL64      = 'https://download.sassafras.com/software/release/current/Installers/Windows/Client/ksp-client-x64.exe'
      ARM64URL   = 'https://download.sassafras.com/software/release/current/Installers/Windows/Client/ksp-client-arm64.exe'

   }
}

function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Checksum\s*=\s*)('.*')"         = "`$1'$($Latest.Checksum32)'"
          "(^\s*Checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
          "(^\s*[$]ARM64Checksum\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumARM64)'"
       }
    }
}

function global:au_BeforeUpdate() { 
   # Need to trick AU to get hash of ARM64 file. This will download the 32-bit installer twice.
   $TempURL64 = $Latest.URL64
   $TempSha = $Latest.Checksum64
   $Latest.URL64 = $Latest.ARM64URL
   $Latest.Checksum64 = $Latest.ChecksumARM64

   Get-RemoteFiles -NoSuffix

   $Latest.ChecksumARM64 = $Latest.checksum64
   $Latest.URL64 = $TempURL64
   $Latest.checksum64 = $TempURL64

   Get-RemoteFiles -NoSuffix

   # This isn't an embedded package, so delete all the installers.
   $toolsDir = Resolve-Path tools
   $Installers = Get-ChildItem $toolsDir -filter '*.exe'
   Foreach ($exe in $Installers) { Remove-Item $exe.FullName }
}


Update-Package -ChecksumFor all
