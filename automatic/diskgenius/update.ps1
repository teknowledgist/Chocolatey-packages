import-module chocolatey-au

function global:au_GetLatest {
   $FreeURL = 'https://www.diskgenius.com/free.php'
   $Page = Invoke-WebRequest -Uri $FreeURL

   $versionline = $Page.AllElements | 
                  Where-Object {$_.tagname -eq 'div' -and $_.innertext -match "^version"} | 
                  Select-Object -first 1 -ExpandProperty innertext
   $version = $versionline -replace '^Version:\s*([0-9.]+).*','$1'

   $URL32 = "https://www.diskgenius.com/dyna_download/?software=DGEngSetup$($version.replace('.','')).exe"

   return @{ 
            Version  = $Version
            URL32    = $URL32
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor all
