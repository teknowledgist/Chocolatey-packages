import-module chocolatey-au

function global:au_GetLatest {
   $DUrl = 'https://www.sassafras.com/client-download/'
   $download_page = Invoke-WebRequest -Uri "$DUrl"

   $null = $download_page.AllElements | 
         Where-Object {$_.tagname -eq 'h3' -and $_.innertext -match '([0-9.]+) for Windows'}
   
   return @{ 
      Version = $Matches[1]
   }
}

function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
       }
    }
}

Update-Package
