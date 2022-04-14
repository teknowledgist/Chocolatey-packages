import-module au

function global:au_GetLatest {
   $ChangeLogURL = 'https://www.zabkat.com/changes.txt'
   $ChangeLog = Invoke-WebRequest -Uri $ChangeLogURL

   $Vline = $ChangeLog.RawContent.split("`n") | ? {$_ -match '^\['} | select -first 1
   $Version = $Vline.split()[0].trim('[]')

   $url32 = 'http://mirror3.free-downloads.net/13343/xplorer2_setup.exe'  #$url32 -replace 'http:','https:'
   $url64 = 'http://mirror3.free-downloads.net/13343/xplorer2_setup64.exe'  #$url64 -replace 'http:','https:'

   return @{ 
      Version = $Version
      URL32   = $url32
      URL64   = $url64
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
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
