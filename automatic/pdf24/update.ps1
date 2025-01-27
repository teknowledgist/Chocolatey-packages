import-module chocolatey-au

function global:au_GetLatest {
   $AllVersions = 'https://creator.pdf24.org/listVersions.php'
   $PageData = Invoke-WebRequest -Uri "$AllVersions" -UseBasicParsing

   $version = ($PageData.rawcontent -split '</?td>')[1]

   $x64row = $pagedata.rawcontent -split '</?tr>' | ? {$_ -match "$version-x64\.msi"}
   $SHA264x64 = $x64row -split '</?td>' | ? {$_ -match '^[0-9a-f]{64}$'}

   $x86row = $pagedata.rawcontent -split '</?tr>' | ? {$_ -match "$version-x86\.msi"}
   $SHA264x86 = $x86row -split '</?td>' | ? {$_ -match '^[0-9a-f]{64}$'}

   return @{ 
      Version    = $version
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
