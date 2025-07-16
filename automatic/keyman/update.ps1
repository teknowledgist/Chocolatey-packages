import-module chocolatey-au

function global:au_GetLatest {
   $DownPage = 'https://keyman.com/windows/download'
   $PageContent = Invoke-WebRequest -Uri $DownPage -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($PageContent.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($PageContent))   # No MS Office
   }
   
   $Null = $HTML.getElementsByTagName('h3') | 
            Where-Object { $_.innertext -match "^Keyman for Windows ([0-9.]+)" }
   $Version = $Matches[1]

   $URL = "https://downloads.keyman.com/windows/stable/$Version/keyman-$Version.exe"

   return @{ 
            Version = $Version
            URL32   = $URL
           }
}


function global:au_SearchReplace {
    @{
      'legal\VERIFICATION.md' = @{
         '(- Version\s+:).*'    = "`${1} $($Latest.Version)"
         '(- URL\s+:).*'    = "`${1} $($Latest.URL32)"
         '(- SHA256\s+:).*' = "`${1} $($Latest.Checksum32)"
      }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Keyman $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none 
