import-module chocolatey-au

function global:au_GetLatest {
   $ArchiveURL = 'https://www.babelstone.co.uk/Software/BabelPad_Versions.html'
   $List = Invoke-WebRequest -Uri $ArchiveURL

   $version = $list.AllElements | 
                  Where-Object {$_.tagname -eq 'td' -and $_.innertext -match '^[0-9.]+$'} | 
                  Select-Object -first 1 -ExpandProperty innertext

   $URL32 = 'https://www.babelstone.co.uk/Software/Download/BabelPad.zip'

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
