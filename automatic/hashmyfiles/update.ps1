import-module au

$releases = 'https://www.nirsoft.net/utils/hash_my_files.html'

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $download_page.RawContent -match 'HashMyFiles v([0-9.]+)' | Out-Null

    @{
      Version = $Matches[1]
      URL32 = 'http://www.nirsoft.net/utils/hashmyfiles.zip'
      URL64 = 'http://www.nirsoft.net/utils/hashmyfiles-x64.zip'
    }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
        "^(x86 CheckSum\s*:).*"        = "`${1} $($Latest.Checksum32)"
        "^(x64 CheckSum\s*:).*"        = "`${1} $($Latest.Checksum64)"
      }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }


try {
  update -ChecksumFor none
} catch {
  $ignore = "Unable to connect to the remote server"
  if ($_ -match $ignore) { Write-Host $ignore; 'ignore' } else { throw $_ }
}
