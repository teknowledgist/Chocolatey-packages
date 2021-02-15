import-module au

function global:au_GetLatest {
   $HomeURL = 'https://www.abstractspoon.com/phpBB/viewforum.php?f=5'
   $PageText = Invoke-WebRequest -Uri $HomeURL

   $null = $PageText.links | 
               Where-Object {$_.innertext -match "([0-9][0-9.]+) is available"} | 
               Select-Object -First 1

   $Version = $Matches[1]

   return @{ 
            Version  = $Version
            URL32    = 'http://abstractspoon.pbwiki.com/f/todolist_exe.zip'
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading ToDoList v$($Latest.Version) zip package"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none -nocheckchocoversion
