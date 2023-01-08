import-module au

function global:au_GetLatest {
<# old way
   $Release = 'https://download.tuxfamily.org/qet/tags/'
   $Tags_page = Invoke-WebRequest -Uri $Release

   $Folder = $Tags_page.links | Select-Object -ExpandProperty href -Last 1
   $Files_page = Invoke-WebRequest -Uri "$Release$($Folder)Windows"

   $Stub64 = $Files_page.links | 
                  Where-Object {$_.href -match 'win64.*\.exe'} | 
                  Select-Object -ExpandProperty href

   $version = ($Stub64.split('-') | Where-Object {$_ -match '%'}) -replace '%2bgit','.'

   $URL64 = "$Release$($Folder)Windows/$Stub64"
#>
   $Repo = 'https://github.com/qelectrotech/qelectrotech-source-mirror'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $SourceFile = $Release.Assets | Where-Object {$_.FileName -like '*.7z'} | Select-Object -ExpandProperty FileName
   $version = ($SourceFile.split('-') | ? { $_ -match '\d\.\d'}).replace('+git','.')
   $URL64 = $Release.Assets | Where-Object {$_.FileName -like '*.exe'} | Select-Object -Last 1 -ExpandProperty DownloadURL

   return @{ 
         Version = $version
         URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.txt" = @{
         "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
         "(^x64 URL\s+:).*"    = "`${1} $($Latest.URL64)"
         "(^x64 SHA256\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading QElectroTech $($Latest.Version) installer file."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
