import-module chocolatey-au

function global:au_GetLatest {
   $ChangeURL = 'https://riot-optimizer.com/changelog/'
   $ChangePage = Invoke-WebRequest -Uri $ChangeURL -UseBasicParsing

   $VersionText = $ChangePage.AllElements | 
                     Where-Object {$_.tagname -eq 'strong' -and $_.innertext -match '^v\.'} | 
                     Select-Object -first 1 -expand innertext
   $Version = $VersionText.split()[1]

   $TYURL = 'https://riot-optimizer.com/thank-you-for-downloading-riot/'
   $TYPage = Invoke-WebRequest -uri $TYURL
   $URL64 = $TYPage.links | Where-Object {$_.innertext -match 'direct'} | Select-Object -ExpandProperty href

   return @{ 
         Version = $version
         URL64   = $URL64 -replace '&amp;','&'
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.md" = @{
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
