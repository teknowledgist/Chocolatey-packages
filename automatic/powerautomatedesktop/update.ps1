import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://learn.microsoft.com/en-us/power-platform/released-versions/power-automate-desktop'
   $ReleasePage = Invoke-WebRequest -Uri "$Release"

   $tableHTML = $ReleasePage.AllElements | 
                  Where-Object {$_.tagname -eq 'table' -and $_.innertext -match 'worldwide'} | 
                  Select-Object -ExpandProperty innerhtml
   $null = $tableHTML.split() | 
                  Where-Object {$_ -match '^<TD>([0-9]+\.[0-9.]+)</TD>'} | 
                  Select-Object -first 1
   $version = $Matches[1]

   $Install = 'https://learn.microsoft.com/en-us/power-automate/desktop-flows/install'
   $InstallPage = Invoke-WebRequest -Uri $Install
   $URL =  $InstallPage.Links | 
               Where-Object {$_.outertext -match "Download the.*installer"} | 
               Select-Object -ExpandProperty href

   return @{ 
      Version = $Version
      URL32   = $URL
   }
}


function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
       }
    }
}

Update-Package