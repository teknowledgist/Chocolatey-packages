import-module chocolatey-au

function global:au_GetLatest {
   $Manifest = 'https://download.sassafras.com/software/release/img-manifest.json'
   $KSPdata = Invoke-RestMethod $Manifest

   return @{ 
      Version    = $KSPdata.version
      Checksum32 = $KSPdata.'ksp-client-i386.exe'.digest
      checksum64 = $KSPdata.'ksp-client-x64.exe'.digest
   }
}

function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
       }
    }
}

Update-Package -ChecksumFor none
