Import-Module -Name Evergreen
Import-Module -Name Chocolatey-AU

function global:au_GetLatest {
   $Meta = Get-EvergreenApp openwebstart

   $x64 = $Meta | Where-Object {$_.architecture -eq 'x64'}

   return @{ 
            Version    = $x64.Version
            URL64      = $x64.URI
           }

}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version +:).*"     = "`${1} $($Latest.Version)"
            "(^- x64 URL +:).*"     = "`${1} $($Latest.URL64)"
            "(^- x64 SHA256 +:).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading OpenWebStart $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
