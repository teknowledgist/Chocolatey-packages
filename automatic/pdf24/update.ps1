import-module au

$Release = 'https://en.pdf24.org/pdf-creator-changelog.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $soon = $download_page.AllElements | Where-Object {
                                          $_.tagname -eq 'div' -and 
                                          $_.class -eq 'date' -and 
                                          $_.innertext -match 'coming soon'
                                       }
   if ($soon) {$OneOrTwo = 2} else {$OneOrTwo = 1}
   
   $text = $download_page.AllElements | 
      Where-Object {$_.tagname -eq 'h2' -and $_.innertext -match '^version'} |
      Select-Object -ExpandProperty innertext -First $OneOrTwo
      
   $version = $text.split()[-1]
   
   $url = "https://download2.pdf24.org/pdf24-creator-$version.msi"

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')"    = "`$1'$($Latest.URL32)'"
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

update
