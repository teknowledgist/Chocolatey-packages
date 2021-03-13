import-module au

function global:au_GetLatest {
   $Release = 'https://download.tuxfamily.org/qet/tags/'
   $Tags_page = Invoke-WebRequest -Uri $Release

   $Folder = $Tags_page.links | Select-Object -ExpandProperty href -Last 1
   $Files_page = Invoke-WebRequest -Uri "$Release$($Folder)Windows"

   $Stub64 = $Files_page.links | 
                  Where-Object {$_.href -match 'win64.*\.exe'} | 
                  Select-Object -ExpandProperty href
   $Stub32 = $Files_page.links | 
                  Where-Object {
                     ($_.href -notmatch 'win64') -and 
                     ($_.href -match '\.exe$')} | 
                  Select-Object -ExpandProperty href

   $version = ($Stub32.split('-') | Where-Object {$_ -match '%'}) -replace '%2bgit','.'

   $URL32 = "$Release$($Folder)Windows/$Stub32"
   $URL64 = "$Release$($Folder)Windows/$Stub64"

   return @{ 
         Version = $version
         URL32   = $URL32
         URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"    = "`${1} $($Latest.URL32)"
         "(^x86 SHA256\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"    = "`${1} $($Latest.URL64)"
         "(^x64 SHA256\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading QElectroTech $($Latest.Version) installer files."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
