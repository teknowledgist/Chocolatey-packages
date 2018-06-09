# First load the functions that the dependency (i.e. ".install") package uses
. "$((pwd).path -replace 'portable','install')\update.ps1"

function global:au_BeforeUpdate() { 
   Write-host "Downloading FastCopy v$($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none