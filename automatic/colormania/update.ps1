import-module chocolatey-au

function global:au_GetLatest {
   $HomeURL = 'http://www.blacksunsoftware.com/colormania.html'
   $PageText = Invoke-WebRequest -Uri $HomeURL -UseBasicParsing

   $PageText.RawContent -split "<|>" | 
               Where-Object {$_ -match "version ([0-9.]+)"} | 
               Select-Object -First 1

   $Version = $Matches[1]

   return @{ 
            Version  = $Version
            URL32    = 'http://www.blacksunsoftware.com/downloads/ColorManiaSetup.exe'
           }
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
   Write-host "Downloading ColorMania v$($Latest.Version) installer"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none -nocheckchocoversion
