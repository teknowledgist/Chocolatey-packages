import-module au

function global:au_GetLatest {
   $DownloadURI = 'http://latexdraw.sourceforge.net/index.html'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $Link = $download_page.links | 
               Where-Object {$_.href -match 'download$' -and $_.innertext -match '^[0-9.]+\s*$'}
   
   $version = $Link.innerText.trim()

   $url32 = "https://sourceforge.net/projects/latexdraw/files/latexdraw/$version/LaTeXDraw-$version-bin.zip"

   return @{ 
            Version  = $version
            URL32    = $url32
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
