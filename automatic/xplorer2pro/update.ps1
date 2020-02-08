import-module au

function global:au_GetLatest {
   $DownloadPage = 'https://www.zabkat.com/alldown.htm'
   $PageContent = Invoke-WebRequest -Uri $DownloadPage
   if ($PageContent.RawContent -match 'Latest version: \d.\d.\d.\d') {
      $Version = $matches[0].split()[-1]
   }

   $url32,$url64 = $PageContent.Links | Where-Object {
                                             ($_.innertext -match 'MAIN download server') -and 
                                             ($_.href -notmatch 'ult|lite') -and 
                                             ($_.href -match '\.exe')} | 
                                        Select-Object -ExpandProperty href

   $url32 = 'http://zabkat.com/dl/xplorer2_setup.exe'  #$url32 -replace 'http:','https:'
   $url64 = 'http://zabkat.com/dl/xplorer2_setup64.exe'  #$url64 -replace 'http:','https:'

   return @{ 
      Version    = $Version
      URL32      = $url32
      URL64      = $url64
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^\s*URL\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^\s*URL64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package -ChecksumFor all