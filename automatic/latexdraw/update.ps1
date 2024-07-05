import-module chocolatey-au

function global:au_GetLatest {
   $AnnounceURI = 'http://latexdraw.sourceforge.net/index.html'
   $announce_page = Invoke-WebRequest -Uri $AnnounceURI

   $Link = $announce_page.links | 
               Where-Object {$_.innerText -eq 'download'} | 
               Select-Object -ExpandProperty href
   
   $version = $Link.split('/')[-2]

   $URL = "https://sourceforge.net/projects/latexdraw/files/latexdraw/$version/latexdraw-$version-win-binaries.zip"

   return @{ 
            Version  = $version
            URL32    = $URL
         }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s*:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s*:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s*:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading LatexDraw $($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none

if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
