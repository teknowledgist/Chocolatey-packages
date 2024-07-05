import-module chocolatey-au

function global:au_GetLatest {
   $HomeURL = 'https://www.softwareok.com/?Download=PhotoResizerOK'
   $PageText = Invoke-WebRequest -Uri $HomeURL -UseBasicParsing

   $Title = ($PageText.rawcontent -split "title>|</title")[1]
   $Version = $title -replace '.* ([0-9.]+) .*','$1'

   return @{ 
            Version  = $Version
            URL32    = 'https://www.softwareok.com/Download/PhotoResizerOK.zip'
            URL64    = 'https://www.softwareok.com/Download/PhotoResizerOK_x64.zip'
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"          = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*"     = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading PhotoResizerOK v$($Latest.Version) zip files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none -nocheckchocoversion
