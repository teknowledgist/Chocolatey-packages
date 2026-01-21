import-module chocolatey-au

function global:au_GetLatest {
   $API = 'https://api.deskflow.org/version'
   $Version = Invoke-WebRequest $API  -UseBasicParsing | Select-Object -ExpandProperty Content

   return @{ 
      Version = $version
      URL64   = "https://github.com/deskflow/deskflow/releases/download/v$Version/deskflow-$($Version)-win-x64.msi"
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version *:).*" = "`${1} $($Latest.Version)"
            "(^- URL *:).*"   = "`${1} $($Latest.URL64)"
            "(^- SHA256 Checksum *:).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Deskflow v$($Latest.Version) installer."
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
