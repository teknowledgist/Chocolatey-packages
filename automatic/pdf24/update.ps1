import-module chocolatey-au

$AllVersions = 'https://creator.pdf24.org/listVersions.php'

function global:au_GetLatest {
   $PageData = Invoke-WebRequest -Uri "$AllVersions" -UseBasicParsing

   $latest = $PageData.RawContent -split '<tr>' | ? {$_ -match '<td>'} | select -first 4

   $version = $latest -split '</?td>' | ? {$_ -match '^[0-9.]+'} | select -first 1

   $x64row = $latest | ? {$_ -match 'x64\.msi'}
   $SHA264x64 = $x64row -split '</?td>' | ? {$_ -match '^[0-9a-f]{64}$'}

   $x86row = $latest | ? {$_ -match 'x86\.msi'}
   $SHA264x86 = $x86row -split '</?td>' | ? {$_ -match '^[0-9a-f]{64}$'}

   return @{ 
      Version = $version
      URL32      = "https://download.pdf24.org/pdf24-creator-$version-x86.msi"
      Checksum32 = $SHA264x86
      URL64      = "https://download.pdf24.org/pdf24-creator-$version-x64.msi"
      Checksum64 = $SHA264x64
      }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^\s*url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

update -ChecksumFor none
