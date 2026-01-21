import-module chocolatey-au


function global:au_GetLatest {
   $Release = 'https://sourceforge.net/projects/ufraw/'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $Title = $download_page.links |
                  Where-Object {$_.href -match 'latest'} |
                  Select-Object -ExpandProperty title
   $EXE = $Title.split() | Where-Object {$_ -match '\.exe'}
   $Version = $EXE.split('-') | 
                  Where-Object {$_ -match '^[0-9.]+$'} | 
                  Select-Object -First 1

   $url = $Release + "files/ufraw/ufraw-$Version/$EXE"

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading UFRaw $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
