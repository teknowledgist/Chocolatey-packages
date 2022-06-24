import-module au

function global:au_GetLatest {
#   $ChangeLogURL = 'https://www.zabkat.com/changes.txt'
#   $ChangeLog = Invoke-WebRequest -Uri $ChangeLogURL

#   $Vline = $ChangeLog.RawContent.split("`n") | ? {$_ -match '^\['} | select -first 1
#   $Version = $Vline.split()[0].trim('[]')
   $MainPage = 'https://www.zabkat.com'
   $PageContent = Invoke-WebRequest -Uri "$MainPage/alldown.htm"
   $section = $PageContent.RawContent -split 'hredge' | 
                  Where-Object {$_ -match 'Professional'}

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
      Version      = $Version
      ManualURL32  = $url32
      ManualURL64  = $url64
   }
}


function global:au_SearchReplace {
    @{
        "legal\VERIFICATION.md" = @{
            "(^- Version\s*:)(.*)"      = "`${1} $($Latest.Version)"
            "(^- x32 SHA256\s*:)(.*)"   = "`${1} $($Latest.Checksum32)"
            "(^- x64 SHA256\s*:)(.*)"   = "`${1} $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Xplorer2 Pro $($Latest.Version) installer file"
   Write-warning "The zabcat.com site won't allow proper download.  " +
                  "It must be manually downloaded from:`n " +
                  $($Latest.ManualURL32) +
                  "`nand`n" +
                  $($Latest.ManualURL64)
}

update -ChecksumFor none
