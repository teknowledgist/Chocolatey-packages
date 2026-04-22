import-module chocolatey-au

$releases = 'https://www.bleachbit.org/download/windows'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
   $Link = ($download_page.links | Where-Object href -match 'portable.zip$' | 
                  Select-Object -First 1 -expand href) -Replace '.*file=', ''
   if ($Link -match '^http') {
      $filename = $Link.split('/')[-1]
   } else { $filename = $Link }
   
   $version = $filename -split '-' | Select-Object -First 1 -Skip 1

   $SumFile = Invoke-WebRequest "https://download.bleachbit.org/bleachbit-$version-sha256sum.txt" -UseBasicParsing
   $Checksum = ($SumFile.content -split '\n' | 
                  Where-Object {$_ -match 'portable\.zip'}).split()[0]

   # figure out if this is a beta release or a normal release.
   $BetasPage = Invoke-WebRequest "https://download.bleachbit.org/beta" -UseBasicParsing 
   $IsBeta = $BetasPage.links | Where-Object {$_.innertext -eq "$version/"}
   if ($IsBeta) {
      $filename = "beta/$version/$filename"
      $version = $version + "-beta"
   }

   @{
      Version     = $version
      URL32       = "https://download.bleachbit.org/$filename"
      Checksum32 = $Checksum
      SumURL      = "https://download.bleachbit.org/bleachbit-$version-sha256sum.txt"
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*" = "`${1} $($Latest.Version)"
            "(^- URL:).*"     = "`${1} $($Latest.URL32)"
            "(^- SHA256+:).*" = "`${1} $($Latest.Checksum32)"
            "^    https.*"    = "    $($Latest.SumURL)"
      }
   }
}

function global:au_BeforeUpdate() { 
Write-host "Downloading BleachBit Portable $($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
