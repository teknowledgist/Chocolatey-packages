import-module chocolatey-au

function global:au_GetLatest {
   $SiteURL = 'https://www.giadamusic.com/'
   $DownPage =  Invoke-WebRequest "$SiteURL" -UseBasicParsing

   $stub = $DownPage.Links | ? {$_.href -like '*windows.zip'} | Select-Object -ExpandProperty href

   $URL = "$SiteURL/$stub"

   $version = $stub.split('-')[1]

   return @{ 
      Version = $version
      URL32   = $URL
   }
}


function global:au_SearchReplace {
   @{
      'legal\VERIFICATION.md' = @{
            '(^- Version:).*' = "`${1} $($Latest.Version)"
            '(^- URL:).*'     = "`${1} $($Latest.URL32)"
            '(^- SHA256+:).*' = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Giada $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
