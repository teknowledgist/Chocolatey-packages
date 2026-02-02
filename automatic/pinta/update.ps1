import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/PintaProject/Pinta'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.').replace('_', '.')
   $Asset = $Release.Assets | Where-Object { $_.FileName -match 'x86_64.*\.exe$' } | Select-Object -First 1 
   $ARM64Asset = $Release.Assets | Where-Object { $_.FileName -match 'arm64.*\.exe$' } | Select-Object -First 1 

   return @{ 
      Version       = $version
      URL32         = $Asset.DownloadURL
      Checksum32    = $Asset.SHA256
      ARM64URL      = $ARM64Asset.DownloadURL
      ARM64Checksum = $ARM64Asset.SHA256
   }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
      'tools\chocolateyinstall.ps1' = @{
         '^(\s*URL64bit\s*= ).*'   = "`${1}'$($Latest.ARM64URL)'"
         '^(\s*Checksum64\s*= ).*' = "`${1}'$($Latest.ARM64Checksum)'"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Pinta $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
