import-module au

function global:au_GetLatest {
   $Release = 'https://www.sassafras.com/support/'
   $download_page = Invoke-WebRequest -Uri "$Release"

   $download_page.AllElements | 
         Where-Object {$_.tagname -eq 'p' -and $_.innertext -match 'KeyAccess ([0-9.]+) for Windows'}
   
   return @{ 
      Version = $Matches[1]
      URL32   = 'https://www.sassafras.com/links/K2Client.exe'
      URL64   = 'https://www.sassafras.com/links/K2Client-x64.exe'
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

# Update-Package

function global:au_BeforeUpdate() { 
   Write-host "Downloading K2 Client $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
