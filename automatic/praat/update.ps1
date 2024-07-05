import-module chocolatey-au

function global:au_GetLatest {
   $Meta = Get-EvergreenApp praat | Where-Object {$_.architecture -eq 'x86'}

   $x86 = $Meta | Where-Object {$_.uri -match '32\.zip$'}
   $x64 = $Meta | Where-Object {$_.uri -match '64\.zip$'}

   return @{ 
            Version    = $x86.Version
            URL32      = $x86.URI
            URL64      = $x64.URI
           }
}

function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^- x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^- x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^- x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^- x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Praat $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
