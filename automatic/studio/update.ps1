import-module au

$Release = 'https://studio.bricklink.com/v2/build/studio.page'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $vstring = $download_page.rawcontent.split('{') | ? {$_ -match 'strVersion'} | select -last 1
   $null = $vstring.split(',') | ? {$_ -match '[0-9._]{3,10}'}
   $versionString = $Matches[0]
   $version = $versionString.replace('_','.')
   
   $url32 = "https://s3.amazonaws.com/blstudio/Studio2.0/Archive/$versionString/Studio+2.0_32.exe"
   $url64 = "https://s3.amazonaws.com/blstudio/Studio2.0/Archive/$versionString/Studio+2.0.exe"


   return @{ 
      Version = $version
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