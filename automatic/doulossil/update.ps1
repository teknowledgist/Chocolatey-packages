import-module chocolatey-au

function global:au_GetLatest {
   $DownURL = 'https://software.sil.org/doulos/download/'
   $DownPage = Invoke-WebRequest $DownURL -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($DownPage)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($DownPage))   # No MS Office
   }

   $link = $html.links | 
            Where-Object {($_.href -like "*.zip") -and ($_.innertext -match 'Doulos')} | 
            Select-Object -First 1   

   $version = ($link.href.split('/-') | ? {$_ -match '^[0-9.]+'}).trim('.zip')

   return @{ 
      Version     = $version
      URL32       = $link.href
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*" = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"     = "`${1} $($Latest.URL32)"
            "^(- SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Duolos SIL font $($Latest.VersionText) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
