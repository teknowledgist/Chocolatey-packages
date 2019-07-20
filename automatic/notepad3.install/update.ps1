import-module au

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $Release = 'https://www.rizonesoft.com/downloads/notepad3/'
   $PageText = Invoke-WebRequest -Uri $Release -UseBasicParsing
#   $ie = New-Object -ComObject "InternetExplorer.Application"
#   $ie.silent = $true
#   $ie.Navigate("https://www.rizonesoft.com/downloads/notepad3/")
#   while($ie.ReadyState -ne 4) {start-sleep -m 100}
#   $body = $ie.Document.body.innerHTML
#   [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
#   Remove-Variable ie

   $downloaduri = 'https://www.rizonesoft.com/downloads/notepad3/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing   
   $link = $download_page.links | Where-Object {$_.class -match 'exe'} | Select-Object -First 1   

   $version = $link.title.split()[-1]
   $filename = $link.outerhtml.split() | Where-Object {$_ -like '*.exe'}
   
#   $version = $filename.split('_') | Where-Object {$_ -match '^[0-9.]+$'}
   $url = "https://www.rizonesoft.com/shkarko/Notepad3/" + $filename 

   return @{ 
            Version  = $Version
            URL32    = $URL
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

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Notepad3 $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase "Notepad3_$($Latest.Version)" 
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
