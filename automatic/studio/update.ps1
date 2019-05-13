import-module au

$Release = 'https://studio.bricklink.com/v2/build/studio.page'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $text = $download_page.Scripts | ? {$_.innertext -match '\.exe'} | select -exp outertext
   
   $urllines = $text.split('{;}') |? {$_ -match '\.exe'}
   $url32 = ($urllines | ? {$_ -match 'win32'}) -replace ".*'(https.*\.exe)'",'$1'
   $url64 = ($urllines | ? {$_ -match 'win64'}) -replace ".*'(https.*\.exe)'",'$1'
   
   $vline = $text.replace('"','').split('{,}') |? {$_ -match '^version'} | select -Last 1
   $version = $vline.replace('_','.').split(':')[-1]
   
   return @{ 
      Version = $version
      URL32   = $url32
      URL64   = $url64
   }
}


function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
          "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
          "(^\s*Url64bit\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
       }
    }
}

Update-Package