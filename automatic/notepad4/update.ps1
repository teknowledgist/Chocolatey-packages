import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/zufuliu/notepad4'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.').replace('r','.')
   # A majority of systems will likely be AVX2 capable. Also, HD and 
   #    multi-language are more inclusive with no harm, so embed 
   #    that build (and keep win32 to round out the embedded status.)
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match 'Notepad4_i18n_Win32.*\.zip'} | Select-Object -Last 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'Notepad4_HD_i18n_AVX2.*\.zip'} | Select-Object -Last 1 -ExpandProperty DownloadURL

   $LatestHT = @{
      Version  = $Version
      URL32    = $URL32
      URL64    = $URL64
   }

   $CSV = @('Language,HD,Processor,URL,SHA256')

   Foreach ($item in ($Release.Assets | Where-Object {$_.FileName -match '^Notepad4'}) ) {
      $split = $item.Filename.split('_')
      if ($split[1] -eq 'HD') { $HD = 'HD' } else { $HD = '' }
      $CSV += ($split[-3],$HD,$split[-2],$item.DownloadURL) -join ','
   }

   $CSV | Out-File '.\tools\BuildChecksums.csv' -Force

   foreach ($line in ($CSV[1..($CSV.count -1)])) {
      $NameCode = $line.split(',')[0..2] -join '_'
      $DLURL = $line.split(',')[-1]
      $LatestHT.Add($NameCode,$DLURL)
   }
   return $LatestHT

}


function global:au_SearchReplace {
   $AssetList = @{}
   $Latest.GetEnumerator().Name | 
               Where-Object {($_ -match '_') -and ($_ -notmatch 'checksum')} | 
               ForEach-Object {
                  $AssetList.add("(^$($_.replace('_',',')),.*)","`${1}," + $Latest."$($_)checksum")
               }

   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*"    = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"        = "`${1} $($Latest.URL32)"
            "^(- Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
            "^(- URL64\s+:).*"      = "`${1} $($Latest.URL64)"
            "^(- Checksum64\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
      '.\tools\BuildChecksums.csv' = $AssetList
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Notepad4 $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -nosuffix

   $Latest.GetEnumerator().Name | Where-Object {$_ -match '_' } | ForEach-Object {
      Write-Host "Downloading $_  version."
      $Latest."$($_)checksum" = Get-RemoteChecksum $Latest.$_
   }

}

update -ChecksumFor none
