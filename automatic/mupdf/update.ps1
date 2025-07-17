import-module chocolatey-au

function global:au_GetLatest {
   $releases = 'https://mupdf.com/releases/history'
   $History_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

   $versionstring = $History_page.rawcontent -split '</?h2>' | 
                        Where-Object { $_ -match '^mupdf' } | Select-Object -first 1
   $version = $versionstring.split() | Where-Object { $_ -match '^[0-9.]+$' }

   return @{
      URL32   = "https://mupdf.com/downloads/archive/mupdf-$version-windows.zip"
      Version = $version
   }
}

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.md" = @{
      "^(- SHA256 Checksum:).*" = "`${1} $($Latest.Checksum32)"
      "^(- URL:\s*).*"          = "`${1}$($Latest.URL32)"
      "^(- Version:\s*).*"      = "`${1}$($Latest.Version)"
    }
  }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading MuPDF v$($Latest.Version) installer"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
