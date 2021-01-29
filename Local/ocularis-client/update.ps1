import-module au

$LocalDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$HostName = Get-Content "$LocalDir\HostName.private"

# View:  http://$HostName/ocularisservice/InstallerWebsite/client.html
$Release = "http://$HostName/ocularisservice/InstallerWebsite"

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri "$Release/client.html"

   $urlstub = $download_page.links | 
               Where-Object {$_.href -match 'client'} | 
               Select-Object -ExpandProperty href
   $url = "$Release/$urlstub" -replace ' ','%20'

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

