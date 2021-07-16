import-module au

function global:au_GetLatest {
   $releases = 'https://mupdf.com/downloads'
   $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

   $url  = $download_page.links | 
               Where-Object {$_.href -match 'windows.zip$'} | 
               Select-Object -First 1 -ExpandProperty href

   $version = $url.split('-')[1]

   return @{
      URL32   = "$releases/$url"
      Version = $version
   }
}

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.md" = @{
      "^(- SHA256 Checksum:).*" = "`${1} $($Latest.Checksum32)"
      "^(- URL:\s*).*"          = "`${1}$($Latest.URL32)"
      "^(- Version:\s*).*"         = "`${1}$($Latest.Version)"
    }
  }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading MuPDF v$($Latest.Version) installer"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
