import-module au

$MainPage = 'http://psydk.org'

function global:au_GetLatest {
   $PageContents = Invoke-WebRequest -Uri "$MainPage/pngoptimizer"

   $stub32 = $PageContents.links |? {$_.href -like "*x86.zip"} | select -ExpandProperty href -First 1
   $stub64 = $PageContents.links |? {$_.href -like "*x64.zip"} | select -ExpandProperty href -First 1

   $version = ($stub64 -split '-' | Where-Object {$_ -match '^[0-9.]+$'})

   return @{ 
            Version    = $version
            URL32      = "$MainPage$Stub32"
            URL64      = "$MainPage$Stub64"
           }
}


function global:au_SearchReplace {
    @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"        = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
         "(^URL64\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^Checksum64\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading PngOptimizer $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
