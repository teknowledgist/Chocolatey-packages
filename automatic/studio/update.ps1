import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.bricklink.com/v3/studio/download.page'
   $download_page = Invoke-WebRequest -Uri "$Release"


   $list = $download_page.RawContent | Select-String -Pattern 'changelog.*?"changelog' -allmatches
   $version = $list.Matches.Value | select-string -Pattern '"strversion":"[0-9._]+"' -allmatches | 
                           ForEach-Object {$_.matches} | 
                           ForEach-Object {[version]($_.groups[0].value.split(':')[-1].trim('"').replace('_','.'))} |
                           Sort-Object | Select-Object -Last 1

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