import-module chocolatey-au

function global:au_GetLatest {
   $ReleasesURL = 'https://www.postgresql.org/ftp/odbc/releases/'
   $ReleasesPage = Invoke-WebRequest -Uri $ReleasesURL -UseBasicParsing

   $LatestDIR = $ReleasesPage.links |
               Where-Object {$_.outerhtml -match '-[0-9_]+<'} |
               Select-Object -ExpandProperty href -first 1

   $LatestPage = Invoke-WebRequest -Uri "$ReleasesURL/$LatestDIR" -UseBasicParsing
   $URLs = $LatestPage.links | 
               Where-Object {$_.outerhtml -match '\.msi<'} | 
               Select-Object -ExpandProperty href

   $url64 = $URLs | Where-Object {$_ -match '_x64'}
   $url32 = $URLs | Where-Object {$_ -match '_x86'}

   $Version = $url64 -replace '.*/REL-([0-9_]+)/.*','$1' -replace '_','.'

   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
           }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s*:).*"      = "`${1} $($Latest.Version)"
         "(^- x86 URL\s*:).*"      = "`${1} $($Latest.URL32)"
         "(^- x86 SHA256\s*:).*" = "`${1} $($Latest.Checksum32)"
         "(^- x64 URL\s*:).*"      = "`${1} $($Latest.URL64)"
         "(^- x64 SHA256\s*:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading psqlodbc $($Latest.AppVersion) zip files"
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
