import-module chocolatey-au

function global:au_GetLatest {
   $ProductID = '105942'
   $MainURL = "https://www.microsoft.com/en-us/download/details.aspx?id=$ProductID"
   $MainPage = Invoke-WebRequest -Uri $MainURL

   $null = $mainpage.RawContent -split ',' | Where-Object {$_ -match '"version":"([0-9.]+)"'} | Select-Object -First 1
   $version = $matches[1]

   $null = $mainpage.RawContent -match '"url":"([^"]+)"'
   $url32 = $matches[1]
   $CSV = @('Code,Language,URL,SHA256')
   $CSV += "en-EN,English,$url32"

   # Gather other languages download info
   $mainpage.RawContent -match 'LocaleDropdown":\[(.*?)]'
   $Languages = $matches[1].trim("}{") -replace '},{',"`r`n" -replace '"cultureCode":"','' -replace '"name":"','' -replace '"',''
   $Languages = $Languages.split("`r`n") | Where-Object {$_ -and $_ -notmatch 'en-us'}
   foreach ($lang in $Languages) {
      Write-Host "Finding URL for:  $Lang"
      $confirmURL = "https://www.microsoft.com/$($Lang.split(',')[0])/download/details.aspx?id=$ProductID"
      $confirmpage = Invoke-WebRequest $confirmURL -UseBasicParsing
      $LangURL = $confirmpage.rawcontent.split('"') | Where-Object {$_ -match '^https.*\.msi$'} | Select-Object -first 1
      $CSV += "$([System.Net.WebUtility]::HtmlDecode($Lang)),$LangURL"
   }
   $CSV | Out-File '.\tools\LanguageChecksums.csv' -Force

   $LatestHT = @{
      Version  = $Version
      URL32    = $URL32
   }
   foreach ($line in $CSV) {
      $LangCode = $line.split(',')[0]
      $LangDL = $line.split(',')[-1]
      $LatestHT.Add($LangCode,$LangDL)
   }
   return $LatestHT
}

function global:au_SearchReplace {
   $LangHT = @{}
   $LangList = @{}
   $Latest.GetEnumerator().Name | Where-Object {$_ -match '^..-..$' } | ForEach-Object {
      $LangHT.add("(^$($_),.*?,).*","`$1$($Latest.$_)," + $Latest."$($_)checksum")
   }
   @{
      'tools\chocolateyInstall.ps1' = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
      'tools\LanguageChecksums.csv' = $LangHT
   }
}

function global:au_BeforeUpdate() {
   $Latest.GetEnumerator().Name | Where-Object {$_ -match '^..-..$' } | ForEach-Object {
      Write-Host "Downloading $_ language version."
      $Latest."$($_)checksum" = Get-RemoteChecksum $Latest.$_
   }
}

Update-Package -ChecksumFor all
