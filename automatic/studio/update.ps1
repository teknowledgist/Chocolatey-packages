import-module au

function global:au_GetLatest {
   $Release = 'https://studio.bricklink.com/v2/build/studio.page'
   $download_page = Invoke-WebRequest -Uri "$Release"

   # Latest version is "early release" so take second to latest
   $Version = $download_page.rawcontent.split('{') | Where-Object {$_ -match 'strVersion'} | 
                  ForEach-Object {$_.split(',')} | 
                  Where-Object {($_ -match '[0-9._]{3,10}') -and ($_ -match 'version')} | 
                  ForEach-Object {[version]($_ -replace '.*?([0-9._]+)"','$1' -replace '_','.')} |
                  Sort-Object | Select-Object -Last 2 | Select-Object -First 1

   $VersionString = $Version.ToString() -replace '(.*)\.(.*)','$1_$2'
   
   $url32 = "https://s3.amazonaws.com/blstudio/Studio2.0/Archive/$versionString/Studio+2.0_32.exe"
   $url64 = "https://s3.amazonaws.com/blstudio/Studio2.0/Archive/$versionString/Studio+2.0.exe"


   return @{ 
      Version = $Version.ToString()
      URL32   = $url32
      URL64   = $url64
   }
}


function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
          "(^\s*Url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
       }
    }
}

Update-Package