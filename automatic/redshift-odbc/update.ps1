import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'https://docs.aws.amazon.com/redshift/latest/mgmt/configure-odbc-connection.html'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $URLs = $download_page.links |
               Where-Object {$_.href -match '\.msi$'} |
               Select-Object -ExpandProperty href -first 2

   $url64 = $URLs | Where-Object {$_ -match 'ODBC64'}
   $url32 = $URLs | Where-Object {$_ -match 'ODBC32'}

   $Version = $url64.split('/') | Where-Object {$_ -match '^v?[0-9.]+$'}

   $DocsURL = $download_page.links |
                  Where-Object {$_.href -match "$version.*Guide"} | 
                  Select-Object -ExpandProperty href -Unique
   $NotesURL = $download_page.links |
                  Where-Object {$_.href -match "$version.*Notes"} | 
                  Select-Object -ExpandProperty href -Unique


   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
            NotesURL = $NotesURL
            DocsURL  = $DocsURL
           }
}


function global:au_SearchReplace {
   @{
      'tools\chocolateyInstall.ps1' = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
      'redshift-odbc.nuspec' = @{
         '<docsUrl>.*</docsUrl>'   = "<docsUrl>$($Latest.DocsURL)</docsUrl>"
         '<releaseNotes>.*</releaseNotes>'   = "<releaseNotes>$($Latest.NotesURL)</releaseNotes>"
      }
   }
}

update -ChecksumFor all
