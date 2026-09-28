import-module chocolatey-au

function global:au_GetLatest {
   $DownURL = 'https://riot-optimizer.com'
   $DownPage = Invoke-WebRequest -Uri "$DownURL/download/" -UseBasicParsing

   $VersionString = $DownPage.links | 
                     Where-Object {$_.href -match 'setup\.exe/?$'} | 
                     Select-Object -first 1 -Expand href
    
    $Version = $VersionString.split('-') | Where-Object {$_ -match '^[0-9.]+$'}
    $Installer = $VersionString.split('/') | Where-Object {$_ -match '\.exe'}

   $ThanksURL = 'https://riot-optimizer.com/download/thanks'
   $TYPage = Invoke-WebRequest -uri "$ThanksURL/$Installer" -usebasicparsing
   $URL64 = $TYPage.links | Where-Object {$_.href -match '\.exe$'} | Select-Object -ExpandProperty href

   return @{ 
         Version = $version
         URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "^(- Version:\s+).*" = "`${1} $($Latest.Version)"
         "^(- URL:\s+).*"     = "`${1} $($Latest.URL64)"
         "^(- SHA256:\s+).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading RIOT $($Latest.Version) installer."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
