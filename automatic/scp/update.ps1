import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.textworld.com/scp/'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($download_page.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($download_page))   # No MS Office
   }

   $link = $html.links | 
            Where-Object {$_.href -like "*.msi"} | 
            Select-Object -First 1   
            
   $url = $Release + $link.href.replace('about:','')

   $version = $url.split('-') | Where-Object {$_ -match '^[0-9.]+$'}

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
   Write-host "Downloading SCP $($Latest.Version) installer file."
   Get-RemoteFiles -Purge
}

update -ChecksumFor none
