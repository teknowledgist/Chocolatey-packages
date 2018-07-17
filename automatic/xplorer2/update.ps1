import-module au

function global:au_GetLatest {
   $DownloadPage = 'https://www.zabkat.com/alldown.htm'
   $PageContent = Invoke-WebRequest -Uri $DownloadPage
   $section = $PageContent.RawContent -split 'hredge' | Where-Object {$_ -match 'lite'}
   $line = $section.split('<>') | Where-Object {$_ -match 'Latest version'}

   $Version = $line -replace '[^0-9.]',''
   
   $url32 = $PageContent.links |
               Where-Object {$_.href -match 'lite.*\.exe'} |
               Select-Object -ExpandProperty href

   return @{ 
      Version    = $Version
      URL32      = $url32
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]URL\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^[$]Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

Update-Package -ChecksumFor 32