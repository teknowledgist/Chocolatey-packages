Import-module au

function global:au_GetLatest {
   $MainURL = 'https://www.microsoft.com/en-us/download/details.aspx?id=58158'
   $MainPage = Invoke-WebRequest -Uri $MainURL

   $version = $MainPage.RawContent -split '</?p>' | Where-Object {$_ -match '^[0-9.]+$'}

   $ID = ($MainPage.rawcontent.split('"') |
                     Where-Object {$_ -match 'confirmation'} |
                     Select-Object -first 1) -replace '.*id=(\d+).*','$1'
   $UID = ($MainPage.rawcontent.split('"') |
                  Where-Object {$_ -match "$ID&"} |
                  Select-Object -first 1) -replace '.*amp;([0-9a-f-]+).*','$1'

   $confirmURL = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=$ID&amp;$UID=1"

   $confirmpage = Invoke-WebRequest $confirmURL -UseBasicParsing

   $URL32 = $confirmpage.rawcontent.split('"') | 
                  Where-Object {$_ -match '\.msi$'} | Select-Object -first 1

   # Gather other languages download info
   $CSV = @('Code|Language|URL|SHA256')
   $select = $MainPage.RawContent -split 'select[^e]' | Where-Object {$_ -match 'newlocale'}
   $list = $select -split '</?option' | Where-Object {$_ -match '^ ?value'}
   $Languages = $list -replace ' ?value=','' -replace '^"','' -replace '">','|'
   foreach ($lang in $Languages) {
      $confirmURL = "https://www.microsoft.com/$($Lang.split('|')[0])/download/confirmation.aspx?id=$ID&amp;$UID=1"
      $confirmpage = Invoke-WebRequest $confirmURL -UseBasicParsing
      $LangURL = $confirmpage.rawcontent.split('"') | Where-Object {$_ -match '\.msi$'} | Select-Object -first 1
      $CSV += "$([System.Net.WebUtility]::HtmlDecode($Lang))|$LangURL"
   }
   $CSV | Out-File '.\tools\LanguageChecksums.csv' -Force

   $LatestHT = @{
      Version  = $Version
      URL32    = $URL32
   }
   foreach ($line in $CSV) {
      $LangCode = $line.split('|')[0]
      $LangDL = $line.split('|')[-1]
      $LatestHT.Add($LangCode,$LangDL)
   }
   return $LatestHT
}

function global:au_SearchReplace {
   $LangHT = @{}
   $LangList = @{}
   $Latest.GetEnumerator().Name | ? {$_ -match '^..-..$' } | % {
      $LangHT.add("(^$($_)\|.*?\|).*","`$1$($Latest.$_)|" + $Latest."$($_)checksum")
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
   $Latest.GetEnumerator().Name | ? {$_ -match '^..-..$' } | % {
      Write-Host "Downloading $_ language version."
      $Latest."$($_)checksum" = Get-RemoteChecksum $Latest.$_
   }
}

Update-Package -ChecksumFor all
