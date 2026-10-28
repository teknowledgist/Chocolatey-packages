import-module chocolatey-au

function global:au_GetLatest {
   $DownURL = 'https://brlcad.org/download/'
   $DownPage = Invoke-WebRequest $DownURL -UseBasicParsing

   $URL64 = $DownPage.links | Where-Object {$_.href -match '\.(msi|exe)'} | Select-Object -Last 1 -ExpandProperty href
   $version = $URL64.split('_') | Where-Object {$_ -match '^[0-9.]+$'}

   return @{ 
      Version = $version
      URL64   = $URL64
   }
}

function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^- URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^- Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading BRL-CAD $($Latest.Version) installer"
   Get-RemoteFiles -Purge -nosuffix 
}

update -ChecksumFor none
