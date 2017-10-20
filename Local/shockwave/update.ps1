import-module au

function global:au_GetLatest {
   $Release = 'https://helpx.adobe.com/shockwave/release-note/release-notes-shockwave-12.html'

   $Page = Invoke-WebRequest -Uri $Release
   $Version = $Page.AllElements | 
                  Where-Object {$_.tagname -eq 'li' -and $_.innertext -match '^[\d\.]+$'} |
                  Select-Object -ExpandProperty innertext -First 1

   # You must go to http://www.adobe.com/products/players/fpsh_distribution1.html to request distribution rights.
   # The actual download page for Shockwave cannot be shared under the agreement

   return @{ 
            Version  = $Version
            URL32    = ''  # From the Software Distribution page
            FileType = 'exe'
           }
}

function global:au_SearchReplace {
   @{
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Shockwave v$($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
