import-module au

function global:au_GetLatest {
   $Homepage = 'http://zabkat.com/index.htm'
   $PageContent = Invoke-WebRequest -Uri $Homepage

   $Version = ($Homepage.content.split() |? {$_ -match 'v[0-9.]{4,7}.*'}) -replace '.*v(.*)','$1'
   
   $DownloadPage = 'http://zabkat.com/alldown.htm'
   $PageContent = Invoke-WebRequest -Uri $DownloadPage
   
   $url = $PageContent.links | ? {$_.href -match 'lite_setup.exe'} |select -First 1 -ExpandProperty href
   
   return @{ 
      Version    = $Version
      URL32      = $url
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

Update-Package