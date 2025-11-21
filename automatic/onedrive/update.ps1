Import-Module -Name Evergreen
Import-Module Chocolatey-AU

function global:au_GetLatest {
   $Meta = Get-EvergreenApp microsoftonedrive | 
            Where-Object {$_.ring -eq 'production' -and 
                           $_.architecture -eq 'x86' -and
                           $_.throttle -eq '100'
                         }
   $Meta = Get-EvergreenApp microsoftonedrive | 
      Where-Object { $_.ring -eq 'production' -and 
         $_.throttle -eq '100'
      }

   $x86 = $Meta | Where-Object {$_.architecture -eq 'x86'}
   $x64 = $Meta | Where-Object {$_.architecture -eq 'x64'}
   $ARM64 = $Meta | Where-Object {$_.architecture -eq 'ARM64'}

   return @{ 
      Version       = $x64.Version
      URL32         = $x86.URI
      Checksum32    = $x86.sha256
      URL64         = $x64.URI
      checksum64    = $x64.sha256
      URLARM64      = $ARM64.URI
      ChecksumARM64 = $ARM64.sha256
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
         "(^\s*url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
         "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
         "(^\s*.packageArgs.url64\s*=\s*)('.*')"      = "`$1'$($Latest.URLARM64)'"
         "(^\s*.packageArgs.Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumARM64)'"
      }
   }
}

Update-Package -nocheckchocoversion -ChecksumFor none
