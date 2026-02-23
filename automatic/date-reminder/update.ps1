import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.horstmuc.de/wrem.htm'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $null = $download_page.rawcontent -split '</?b>' |
               Where-Object {$_ -match '^Reminder ([0-9.]+)$'}

   $version = $Matches[1]

   return @{ 
            Version = $version
            URL32   = 'https://www.horstmuc.de/win/reminder.zip'
            URL64   = 'https://www.horstmuc.de/win64/reminder64.zip'
           }
}


function global:au_SearchReplace {
    @{
      'legal\VERIFICATION.md' = @{
         '(- Version\s+:).*'      = "`${1} $($Latest.Version)"
         '(- 32-bit SHA256\s+:).*' = "`${1} $($Latest.Checksum32)"
         '(- 64-bit SHA256\s+:).*' = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading Reminder $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
