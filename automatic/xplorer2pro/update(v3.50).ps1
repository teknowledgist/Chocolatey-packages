import-module au

function global:au_GetLatest {
   $DownloadPage = 'https://www.zabkat.com/alldown.htm'
   $PageContent = Invoke-WebRequest -Uri $DownloadPage
   $section = $PageContent.RawContent -split 'hredge' | ? {$_ -match 'old version 3.50'}
   $line = $section -split '<li>' |? {$_ -match 'Professional edition'}

   $Version = ($line -replace '.*build (\d\d\d\d):.*','$1' -split '' | ? {$_ -match '.'} ) -join '.'
   
   $url32,$url64 = select-string '"(.*?\.exe)"' -InputObject $line -AllMatches |% {$_.matches.value.trim('"')}

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