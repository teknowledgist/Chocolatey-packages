import-module au

function global:au_GetLatest {
   $Release = 'https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0'
   
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $versionstring = $download_page.RawContent -split ">|<" | 
                     Where-Object {$_ -match '^Version'} | 
                     Select-Object -first 1
   $version = $versionstring.split()[1]
   
   $url = $download_page.Links | 
                  Where-Object {($_ -match $version) -and ($_.href -like 'http*')} | 
                  Select-Object -First 1 -ExpandProperty href
   if (-not $url) {
      # MS seeme to recycle download links for a few versions in a row
      $CIcontent = Get-Content 'tools\chocolateyInstall.ps1'
      $url = ($CIcontent -match '^   url\s*=' ).split()[-1].trim("'")
   }

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

Update-Package -nocheckchocoversion
