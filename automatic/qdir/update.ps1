import-module chocolatey-au

function global:au_GetLatest {
   $HomeURL = 'https://www.softwareok.com/?Download=Q-Dir'
   $PageText = Invoke-WebRequest -Uri $HomeURL -UseBasicParsing

   $Title = ($PageText.rawcontent -split "title>|</title")[1]
   $Version = $title -replace '.* ([0-9.]+) .*','$1'

   return @{ 
            Version  = $Version
            URL32    = 'https://www.softwareok.com/Download/Q-Dir_Installer.zip'
            URL64    = 'https://www.softwareok.com/Download/Q-Dir_Installer_x64.zip'
           }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^- x86 Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
         "(^- x64 Checksum\s+:).*"     = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Q-Dir v$($Latest.Version) zip files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none -nocheckchocoversion
