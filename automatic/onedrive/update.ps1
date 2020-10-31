import-module au

function global:au_GetLatest {
   $Release = 'https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0'
   
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $p = $download_page.RawContent -split "</?p>" | Where-Object {$_ -match 'Download OneDrive for Windows'}
   
   $null = $p -match 'href="([^"]+)'
   $url = $Matches[1]

   $versionstring = $download_page.RawContent -split ">|<" | 
                     Where-Object {$_ -match '^Version'} | 
                     Select-Object -first 1
   $version = $versionstring.split()[1]

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package
