import-module au

function global:au_GetLatest {
   $Release = 'https://helpx.adobe.com/shockwave/release-note/release-notes-shockwave-12.html'

   $Page = Invoke-WebRequest -Uri $Release
   $Version = $page.RawContent -split '</?li>' | 
                  Where-Object {$_ -match '^(\d|\.)+$'} | 
                  Select-Object -First 1

   # You must go to http://www.adobe.com/products/players/fpsh_distribution1.html to request distribution rights.
   # The actual download page for Shockwave cannot be shared under the agreement
   $Downloads = '<redacted>'

   $DownloadPage = Invoke-WebRequest -Uri $Downloads
   $DownloadStub = $DownloadPage.Links |
                     Where-Object {$_.innertext -match 'MSI Installer'} |
                     Select-Object -ExpandProperty href -First 1
   $DownloadURL = "https://www.adobe.com$DownloadStub"

   return @{ 
            Version  = $Version
            URL32    = $DownloadURL
            FileType = 'msi'
           }
}

function global:au_SearchReplace {
   @{
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Shockwave v$($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix -FileNameBase "sw_lic_full_installer_v$($Latest.Version)"
}

update -ChecksumFor none
