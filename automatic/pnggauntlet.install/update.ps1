import-module au

function global:au_GetLatest {
   $Notes = 'https://pnggauntlet.com/changelog/'
   $NotesText = Invoke-WebRequest -Uri $Notes

   $AppVersion = $NotesText.AllElements | 
                  ? {$_.tagname -eq 'h5' -and $_.innertext -match 'PNGGauntlet [0-9.]+'} | 
                  select -First 1 -ExpandProperty innertext
   $AppVersion = $AppVersion -replace '.*? ([0-9.]+) .*','$1'
   
   $HomeURL = 'https://pnggauntlet.com/'
   $MainPage = Invoke-WebRequest -Uri $HomeURL
   $URLStub = $MainPage.Links |? {$_.href -match 'exe'} |select -expandproperty href
   
   return @{ 
            Version    = $AppVersion
            URL32      = "$HomeURL$URLStub"
            AppVersion = $AppVersion
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.AppVersion)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading PNGGauntlet$($Latest.AppVersion)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
