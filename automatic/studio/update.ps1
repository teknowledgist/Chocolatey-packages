import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.bricklink.com/v3/studio/download.page'
   $download_page = Invoke-WebRequest -Uri "$Release"

   $list = $download_page.RawContent | Select-String '"strVersion":"[0-9._]+' -AllMatches
   $Version = $list.matches | Select-Object -exp value | 
      ForEach-Object {[version]($_.split('"')[-1].replace('_', '.')) } | 
      Sort-Object | Select-Object -Last 1

   $VersionString = $Version.ToString() -replace '(.*)\.(.*)','$1_$2'
   
   $url32 = "https://studio.download.bricklink.info/Studio2.0/Archive/$versionString/Studio+2.0_32.exe"
   $url64 = "https://studio.download.bricklink.info/Studio2.0/Archive/$versionString/Studio+2.0.exe"

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