<#
.SYNOPSIS
   Gathers info on the latest release of a project on GitHub
.Description
   GitHub has made it very difficult to scrape their web pages for information
   about a project.  They do have a comprehensive API however.  This script 
   API calls to collect information about the latest release of a project.  In
   particular, it gathers the tag (typically containing the version), the 
   description and the name, date, size, and download URL of all the assets
   for the release.
   The API does have a "speed limit" of 60 queries per hour.  In most, expected 
   use-cases for this script (primarily for Chocolatey Automatic Update packages), 
   users won't come close to that limit.  If the limit is a concern, this 
   script can accept, collect and cache (encrypted), or read a cached API Key 
   ("Personal Access Token":
   https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
   to increase the limit to 5000 queries per hour.

.Parameter URL
   (Required) The URL to the GitHub repository in the form: "https://[www.]github.com/<owner>/<repo>
.Parameter AccessToken
   The actual API Key as a plaintext string.  This is not a recommended option,
   but if the API Key is needed and available as plain text this is how to provide
   it.  
   Default Value: <none>
.Parameter TokenAsCred
   Script will open a credential request window to collect the API Key in the 
   password field (while ignoring any value provided in the username field).
   The value will be cached as an secure string for future use.
   Default value: $false
.Output
   A custom object containing the release name, release tag (typically, the 
   version), the description and all the asset values of name, date, size, and 
   download URL for the release.  
.Example
   Get-LatestReleaseInfo -URL 'https://github.com/torakiki/pdfsam'
   Information for the latest release of PDFSam will be collected and returned.
   If an encrypted personal access token is found in the user profile, it will 
   be used to authenticate to GitHub.  If one is not found, the information will 
   still be collected unless there have been more than 60 previous queries 
   within the hour.
.Example
   Get-LatestReleaseInfo -URL 'https://github.com/torakiki/pdfsam' -AccessToken <plaintext token>
   The same query and results as above, but the provided access token will be 
   used and will not be stored anywhere.
.Example
   Get-LatestReleaseInfo -URL 'https://github.com/torakiki/pdfsam' -TokenAsCred
   This will first request credentials in which the user can provide any username
   and a GitHub Personal Access Token for the password.  The access token will be
   stored encrypted within the user profile, and information for the latest release
   of PDFSam will be collected and returned as above.
.Notes
   Copyright 2022 Teknowledgist

   This script/information is free: you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation, either version 2 of the 
   License, or (at your option) any later version.

   This script is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   The GNU General Public License can be found at <http://www.gnu.org/licenses/>.
#>
Function Get-LatestReleaseOnGitHub {
   [CmdletBinding(DefaultParametersetName='Token')]
   Param(
      [Parameter(Position=0)]   
      [ValidateNotNullOrEmpty()]
      [string]$URL = $null,

      [Parameter(ParameterSetName='Token',Position=1)]    
      [ValidateNotNullOrEmpty()]
      [string]$AccessToken = $null,

      [Parameter(ParameterSetName='Creds',Position=1)]    
      [Switch]$TokenAsCred
   )

   if ($URL -match '^https?://(?:www.)?github\.com/([^/]+)/?([^/]+)?(?:/.*)?$') {
      $ownerName = $Matches[1]
      if ($Matches.Count -gt 2) {
         $repositoryName = $Matches[2]
      }
   } else {
      Write-Warning "URL must be in the form 'http[s]://[www.]github.com/<owner>/<repo>'."
      Throw 'URL not in recognized form.'
   }
   $LatestURL = "https://api.github.com/repos/$OwnerName/$RepositoryName/releases/latest"

   $headers = @{
      'Accept' = 'application/vnd.github.v3+json'
      'User-Agent' = 'GetLatest@GitHub'
   }


   $accessTokenFilePath = Join-Path $env:LOCALAPPDATA 'LatestReleaseOnGH\accessToken.txt'
   if ($PSBoundParameters.ContainsKey('TokenAsCred')) {
      # Collect the access token in a PSCredential object
      $CredMessage = 'Provide your GitHub API Token in the Password field.  The username field is required but will be ignored.' + 
                  '  ***The API Token will be cached across PowerShell sessions.  If the password is blank, any cached password will be erased. ***'
      $Credential = Get-Credential -Message $CredMessage

      if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
         # Erase any existing cached token when an empty credential is provided
         Remove-Item $accessTokenFilePath -Force -ErrorAction SilentlyContinue
         Write-Verbose 'Cached Access Token has been erased.'
         $NoTokenMsg = 'Access Token was empty/blank. '
      } else {
         $AccessToken = $Credential.GetNetworkCredential().Password
         Write-Verbose "If the provided Access Token is valid and active, it will be cached."
         $SaveNew = $true
      }
   } else {
      if (-not $AccessToken) {
         If (Test-Path $accessTokenFilePath) {
            $content = Get-Content -Path $accessTokenFilePath -ErrorAction Ignore
            if (-not [String]::IsNullOrEmpty($content)) {
               $secureString = $content | ConvertTo-SecureString
               Write-Verbose "Retrieving Access Token from cache file.  This value can be cleared in the future using the 'Credential' switch and providing an empty password."
               $accessTokenCredential = New-Object System.Management.Automation.PSCredential 'ignored', $secureString
               $AccessToken = $accessTokenCredential.GetNetworkCredential().Password
            } else {
               $NoTokenMsg = "Access Token was empty/blank. "
            }
         } else {
            $NoTokenMsg = "No cached Access Token found. "
         }
      }
   }
   if (-not $AccessToken) {
      Write-Warning "$NoTokenMsg GitHub will limit queries to 60 per hour."
   } else {
      $headers.Authorization = "token $AccessToken"
   }

   $originalSecurityProtocol = [Net.ServicePointManager]::SecurityProtocol
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

   $IWRparams = @{
      Uri = $LatestURL
      Method = 'Get'
      Headers =  $headers
      UseDefaultCredentials = $true
      UseBasicParsing = $true
      TimeoutSec = 0
   }
   Try {
      $result = Invoke-WebRequest @IWRparams
   } catch {
      if ($_.Exception.Response.StatusCode.value__ -eq 404) {
         Write-Warning "The URL, '$URL' does not appear to exist."
      } elseif ($_.Exception.Response.StatusCode.value__ -eq 401) {
         Write-Warning 'The provided access token is not authorized to access this repository.'
      }
      Throw $_.Exception.Message
   } finally {
      [Net.ServicePointManager]::SecurityProtocol = $originalSecurityProtocol
   }

   if ($SaveNew) {
      # This comes after the query because only working tokens should be cached
      If (-not (Test-Path $accessTokenFilePath)) { New-Item -Path $accessTokenFilePath -Force }
      $Credential.Password | ConvertFrom-SecureString | Set-Content -Path $accessTokenFilePath -Force
   }

   if ($result.StatusCode -eq 202) {
      Throw 'The server is busy right now.  Please try again later.'
   }

   $finalResult = $result.Content | ConvertFrom-Json

   $defaultDisplaySet = 'Name','Tag','AssetCount','Description'
   #Create the default property display set
   $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet',[string[]]$defaultDisplaySet)
   $PSStandardMembers = [Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

   $InfoObject = [pscustomobject]@{
      Name          = $finalResult.Name
      Tag           = $finalResult.tag_name | Select-Object -first 1
      Description   = $finalResult.body
      TarballURL    = "https://github.com/$ownerName/$repositoryName/archive/refs/tags/$($finalResult.tag_name | Select-Object -first 1).tar.gz"
      ZipballURL    = "https://github.com/$ownerName/$repositoryName/archive/refs/tags/$($finalResult.tag_name | Select-Object -first 1).zip"
      AssetCount    = $finalResult.assets.count
      Assets        = foreach ($item in $finalResult.assets) {
                        [PSCustomObject]@{
                           FileName     = $item.name
                           CreationDate = get-date $item.created_at
                           Size         = $item.size
                           DownloadURL  = $item.Browser_download_url
                           SHA256       = $item.digest | Where-Object {$_ -match '^sha256:'} | 
                                                         ForEach-Object {$_ -replace '^sha256:',''}
                        }
                     }
   }
   $InfoObject.PSObject.TypeNames.Insert(0,'Release.Information')
   $InfoObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers

   $InfoObject
}

Set-Alias Get-LaRGH Get-LatestReleaseOnGitHub

Export-ModuleMember -Function Get-LatestReleaseOnGitHub -Alias Get-LaRGH
