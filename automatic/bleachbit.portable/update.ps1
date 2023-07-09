import-module au

$releases = 'https://www.bleachbit.org/download/windows'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
   $filename = ($download_page.links | Where-Object href -match 'portable.zip$' | 
                  Select-Object -First 1 -expand href) -Replace '.*file=', ''
   $version = $filename -split '-' | Select-Object -First 1 -Skip 1

   # figure out if this is a beta release or a normal release.
   $BetasPage = Invoke-WebRequest -UseBasicParsing "https://download.bleachbit.org/beta"
   $IsBeta = $BetasPage.links | Where-Object {$_.innertext -eq "$version/"}

   if ($IsBeta) {
      $filename = "beta/$version/$filename"
      $version = $version + "-beta"
   }

   @{
      Version = $version
      URL32   = "https://download.bleachbit.org/$filename"
      SumURL  = "https://download.bleachbit.org/bleachbit-$version-sha256sum.txt"
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
