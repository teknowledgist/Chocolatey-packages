import-module chocolatey-au

function global:au_GetLatest {
   $DownURL = 'https://software.sil.org/charis/download/'
   $DownPage = Invoke-RestMethod $DownURL

   $null = $DownPage -match 'href="([^"]+\.zip)"'
   
   $URL = $matches[1]
   
   $version = ($URL.split('/-') | ? {$_ -match '^[0-9.]+'}).trim('.zip')

   return @{ 
      Version     = $version
      URL32       = $URL
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*" = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"     = "`${1} $($Latest.URL32)"
            "^(- SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Charis SIL font $($Latest.VersionText) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
