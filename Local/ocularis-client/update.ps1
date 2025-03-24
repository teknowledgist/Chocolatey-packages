import-module chocolatey-au

$LocalDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
if (Test-Path "$LocalDir\HostName.private") {
   $HostName = Get-Content "$LocalDir\HostName.private"

   # View:  http://$HostName/ocularisservice/InstallerWebsite/client.html
   $extra = '/client.html'
   $Release = "http://$HostName/ocularisservice/InstallerWebsite"
}
if (-not $HostName) {
   $Release = 'https://www.qognify.com/support-training/software-downloads/'
   $extra = ''
}


function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri "$Release$extra"

   $urlstub = $download_page.links | 
               Where-Object {$_.href -match 'ocularis.*client.*\.exe'} | 
               Select-Object -ExpandProperty href -First 1
   if ($urlstub -match '^http') {
      $url = $urlstub
   } else {
      $url = "$Release/$urlstub" -replace ' ','%20'
   }
   $url = $url -replace ' ','%20'

   $version = $download_page.RawContent.split('> <') | Where-Object {$_ -match 'v[0-9.]+'}
   $version = $version.trim('v')

   return @{ Version = $version; URL = $url }
}

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Ocularis client $($Latest.Version) installer."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none -NoCheckChocoVersion

