import-module chocolatey-au

function global:au_GetLatest {
   $MainPage = 'https://www.zabkat.com'
   $PageContent = Invoke-WebRequest -Uri "$MainPage/alldown.htm"  -UseBasicParsing
   $section = $PageContent.RawContent -split 'green' | 
                  Where-Object {$_ -match 'ultimate'}

   $VersionLine = $section.split('<>') | 
                     Where-Object {$_ -match 'Latest version'} | Select-Object -First 1
   $Version = $VersionLine -replace '[^0-9.]',''

   $HREF32Line = ($section | Where-Object {$_ -match '\(32 bit\)'}).split('<>') | 
                  Where-Object {$_ -match 'href="(.*)"'} | Select-Object -First 1
   $url32 = "http://zabkat.com/$($Matches[1])"

   $HREF64Line = ($section | Where-Object {$_ -match '\(64 bit\)'}).split('<>') | 
                  Where-Object {$_ -match 'href="(.*)"'} | Select-Object -First 1
   $url64 = "http://zabkat.com/$($Matches[1])"

   return @{ 
      Version  = $Version
      URL32    = $url32
      URL64    = $url64
      Filetype = 'exe'
      Options  = @{
         Headers = @{
            'authority' = 'www.zabkat.com'
            'referer'   = 'https://www.zabkat.com/alldown.htm'
         }
      }
   }
}


function global:au_SearchReplace {
    @{
        "legal\VERIFICATION.md" = @{
            "(^- Version\s*:)(.*)"      = "`${1} $($Latest.Version)"
            "(^- x86 SHA256\s*:)(.*)"   = "`${1} $($Latest.Checksum32)"
            "(^- x64 SHA256\s*:)(.*)"   = "`${1} $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Xplorer2 Ultimate $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -FileNameBase 'xplorer2ult_setup' -FileNameSkip 12
}

update -ChecksumFor none
