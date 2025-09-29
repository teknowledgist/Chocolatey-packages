import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/zufuliu/notepad4'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.').replace('r','.')
   # A majority of systems will likely be AVX2 capable. Also, HD and 
   #    multi-language are more inclusive with no harm, so embed 
   #    that build (and keep win32 to round out the embedded status.)
   $x86build = $Release.Assets | Where-Object {$_.FileName -match 'Notepad4_i18n_Win32.*\.zip'} | Select-Object -Last 1 DownloadURL,SHA256
   $x64build = $Release.Assets | Where-Object {$_.FileName -match 'Notepad4_HD_i18n_AVX2.*\.zip'} | Select-Object -Last 1 DownloadURL,SHA256


   $CSV = @('Language,HD,Processor,URL,SHA256')

   Foreach ($item in ($Release.Assets | Where-Object {$_.FileName -match '^Notepad4'}) ) {
      $split = $item.Filename.split('_')
      if ($split[1] -eq 'HD') { $HD = 'HD' } else { $HD = '' }
      $CSV += ($split[-3],$HD,$split[-2],$item.DownloadURL,$item.SHA256) -join ','
   }

   $CSV | Out-File '.\tools\BuildChecksums.csv' -Force

Write-Host "got here"
   return @{
      Version    = $Version
      URL32      = $x86build.DownloadURL
      Checksum32 = $x86build.SHA256
      URL64      = $x64build.DownloadURL
      Checksum64 = $x64build.SHA256
   }

}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*"    = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"        = "`${1} $($Latest.URL32)"
            "^(- Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
            "^(- URL64\s+:).*"      = "`${1} $($Latest.URL64)"
            "^(- Checksum64\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Notepad4 $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
