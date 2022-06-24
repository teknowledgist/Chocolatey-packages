import-module au

function global:au_GetLatest {
   $ChangeLogURL = 'https://www.zabkat.com/changes.txt'
   $ChangeLog = Invoke-WebRequest -Uri $ChangeLogURL

   $Vline = $ChangeLog.RawContent.split("`n") | ? {$_ -match '^\['} | select -first 1
   $Version = $Vline.split()[0].trim('[]')

   return @{ 
      Version = $Version
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
   Write-host "Downloading Xplorer2 Ultimate $($Latest.Version) installer file"
   Write-warning "The zabcat.com site won't allow proper download.  It must be manually downloaded."
}

update -ChecksumFor none
