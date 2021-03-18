Import-module au

function global:au_GetLatest {
   $MainURL = 'https://www.microsoft.com/en-us/download/details.aspx?id=58158'
   $MainPage = Invoke-WebRequest -Uri $MainURL
   $select = $MainPage.RawContent -split "select[^e]" | ? {$_ -match 'newlocale'}
   $list = $select -split '</?option' | ? {$_ -match '^ ?value'}
   $Language = $list -replace ' ?value=','* ' -replace '"','**' -replace '>',' --> '

   $version = $MainPage.RawContent -split "</?p>" | ? {$_ -match '^[0-9.]+$'}

   $ID = ($MainPage.rawcontent.split('"') |? {$_ -match 'confirmation'} |select -first 1) -replace '.*id=(\d+).*','$1'
   $UID = ($MainPage.rawcontent.split('"') |? {$_ -match "$ID&"} |select -first 1) -replace '.*amp;([0-9a-f-]+).*','$1'

   $confirmURL = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=$ID&amp;$UID=1"

   $confirmpage = Invoke-WebRequest $confirmURL -UseBasicParsing

   $URL32 = $confirmpage.rawcontent.split('"') | ? {$_ -match '\.msi$'} | select -first 1

   return @{ 
            Version  = $Version
            URL32    = $URL32
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor all
