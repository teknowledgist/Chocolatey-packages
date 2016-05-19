$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName  = 'ublockorigin-mozilla'
$PackageDir   = Split-Path (Split-Path -parent $MyInvocation.MyCommand.Definition)
$DownloadDir  = Join-Path $PackageDir 'Download'
$SupportedApps = 'Firefox','Pale Moon','Cyberfox'

# This is the URL to get it from Mozilla
#$DownloadUrl  = 'https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi'
# The following will get the latest release on GitHub
$request = [System.Net.WebRequest]::Create('https://github.com/gorhill/uBlock/releases/latest')
$request.AllowAutoRedirect=$true
try {
    $response=$request.GetResponse()
    $BaseUrl = $response.ResponseUri.AbsoluteUri
    $response.Close()
} catch {throw “ERROR: $_”}
$DownloadUrl = $BaseUrl + '/uBlock0.firefox.xpi'

$UserArguments = @{}
 
# Parse the packageParameters using good old regular expression
if ($env:chocolateyPackageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'
 
    if ($env:chocolateyPackageParameters -match $match_pattern ){
        $results = $env:chocolateyPackageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
           $UserArguments.Add(
               $_.Groups[$option_name].Value.Trim(),
               $_.Groups[$value_name].Value.Trim()
           )
       }
    }
    else { Throw 'Package Parameters were found but were invalid (REGEX Failure)' }
} else { Write-Debug 'No Package Parameters Passed in' }

if ($UserArguments.ContainsKey('AllUsers')) {
   Write-Host 'You want to install uBlock Origin for current users (as well as future users).'
   $SubDir = 'browser\extensions'
   if ($UserArguments.ContainsKey('AutoEnable')) {
      Write-Host 'You want application-scope Add-ons to be automatically enabled.'
   }
} else {
   $SubDir = 'Distribution\Extensions'
}

$InstallFor = $SupportedApps

foreach ($app in $SupportedApps) {
   if ($UserArguments.ContainsKey(${'Not' + $app.replace(' ','')})) {
      Write-Host "You do not want to install for $app."
      $InstallFor = $InstallFor | Where-Object {$_ -notmatch $app}
   }
}

<#
if ($UserArguments.ContainsKey('NotFirefox')) {
   Write-Host 'You do not want to install for Firefox.'
   $InstallFor = $InstallFor | Where-Object {$_ -notmatch 'Firefox'}
}

if ($UserArguments.ContainsKey('NotPaleMoon')) {
   Write-Host 'You do not want to install for Pale Moon.'
   $InstallFor = $InstallFor | Where-Object {$_ -notmatch 'Pale Moon'}
}

if ($UserArguments.ContainsKey('NotCyberfox')) {
   Write-Host 'You do not want to install for Cyberfox.'
   $InstallFor = $InstallFor | Where-Object {$_ -notmatch 'Cyberfox'}
}
#>

$AppRegex = $InstallFor -join '|'

$RegistryLocation = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall')
If ($BitLevel -eq '64') {
   # don't forget 32-bit installs on 64-bit systems
   $RegistryLocation += 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$Browsers = @()
foreach ($CurrentReg in $RegistryLocation) {
   $Browsers += Get-ItemProperty "$CurrentReg\*" | Where-Object { $_.displayname -match $AppRegEx}
} 

If (-not $Browsers) {
   Throw 'No supported browsers can be found.  Install aborted.'
} else {
   # Download plugin
   Get-ChocolateyWebFile $packageName $DownloadDir $DownloadURL
}

foreach ($Browser in $Browsers) {
   $AddOnPath = Join-Path $Browser.InstallLocation $SubDir
   try { Copy-Item "$DownloadDir\*.xpi" $AddOnPath -Force }
   catch {throw "Error including add-on in $($Browser.displayName)"}

   if ($UserArguments.ContainsKey('AllUsers') -and $UserArguments.ContainsKey('AutoEnable')) {
      $makecfg = $false
      $makejs = $false
      $n = 0
      $cfgName = 'mozilla.cfg'
      $jsPath = Join-Path $Browser.InstallLocation 'defaults\pref\local-settings.js'
      $cfgPath = Join-Path $Browser.InstallLocation $cfgName

      if (-not (Test-Path $jsPath)) {
         $makejs = $true
         Write-Debug "'$jsPath' file does not exist.  Will create."
      } else {
         $jsfile = Get-Content $jsPath

         # If the js file is empty, make it (later)
         if (-not $jsfile) {
            $makejs = $true
            Write-Debug "'$jsPath' file is empty.  Will populate."
         } else {
            # Have to check for certain settings
            # Determine if a config file is already specified.
            if (($jsfile -join "`n") -match "general\.config\.filename.+[`'`"](?<cfgname>.*)[`'`"]") {
               $cfgName = $Matches['cfgname']
               $cfgPath = Join-Path $Browser.InstallLocation $cfgName
               Write-Debug "Config file is pre-set as '$cfgPath'"

               # Is the config file obscured? (default is rot13)
               if (($jsfile -join "`n") -match 'general\.config\.obscure_value.+?(?<rotVal>\d+)') {
                  $n = $Matches['rotVal']
                  Write-Debug "Obfuscation of pre-defined config file is pre-set to rot$n."
                  # Insert Get-rotX function here
               } else { 
                  $n = 13 
                  Write-Debug 'Obfuscation of pre-defined config file is defaulted to rot13.'
               }

               # If the cfg file doesn't exist, make it (later)
               if (-not (Test-Path $cfgPath)) {
                  $makecfg = $true
                  Write-Debug "'$cfgPath' file does not exist.  Will create."
               } else {
                  $cfgfile = Get-Content $cfgPath

                  # If the cfg file is empty, make it (later)
                  if (-not $cfgfile) {
                     $makecfg = $true
                     Write-Debug "$cfgPath' file is empty.  Will populate."
                  } else {
                     # Unobscure contents (if needed)
                     if ($n -ne 0) { $cfgfile = $cfgfile | % {Get-rotX $_ $n} }

                     if (($cfgfile -join "`n") -match '(.*(extensions\.autoDisableScopes).+?)(?<scopes>\d+)(.*)') {
                        # Only remove the scope_application block if it is still present.
                        If (@(4,5,6,7,12,13,14,15) -contains $Matches['scopes']) {
                           $cfgfile = $cfgfile -replace ".+$($Matches[2]).+",(
                                                         "//--> Chocolatey-uBlock-Origin scope modification`r`n" +
                                                         $Matches[1] + ($Matches['scopes'] - 4) + $Matches[3]
                                                         )
                           $makecfg = $true
                           Write-Debug 'Enabling application scope from pre-set value.'
                        }
                        Write-Debug 'Add-on application scope previously disabled.'
                     } else {
                        # as the default scope is 15, if the setting is missing, it must be changed.
                        $cfgfile = $cfgfile + 
                                    '//--> Chocolatey-uBlock-Origin scope modification' +
                                    'pref("extensions.autoDisableScopes", 11);'
                        $makecfg = $true
                        Write-Debug 'Enabling application scope from default value.'
                        
                        # Re-obscure contents (if needed)
                        if ($n -ne 0) { $cfgfile = $cfgfile | % {Get-rotX $_ -$n} }
                     }
                  } #end else (i.e. cfg file is not empty)
               } #end else (i.e. cfg file exists)
            } else {
               # if the js doesn't identify a cfg, then must specify and make cfg
               $jsfile = $jsfile + 
                        '//--> Chocolatey-uBlock-Origin cfg file definition' +
                        "pref(`"general.config.filename`", `"$cfgName`");" +
                        "pref(`"general.config.obscure_value`", $n);"
               $makejs = $true
               Write-Debug 'Defining config file in pre-existing js.'
               $makecfg = $true
            }
         } #end else (i.e. js file is not empty -- checking/modifying existing settings files)
      } #end else (i.e. js file exists)


      if ($makejs) {
         if (-not $jsfile) {
            [array]$jsfile = '//--> Chocolatey-uBlock-Origin cfg file definition' +
                              "pref(`"general.config.filename`", `"$cfgName`");" +
                              "pref(`"general.config.obscure_value`", $n);"
         } 
         Write-Debug "Writing '$jsPath'."
         try { $jsfile | Out-File $jsPath -Encoding ascii -Force }
         catch { throw "Error writing $jsPath." }
      }

      If ($makecfg) {
         if (-not $cfgfile) {
            [array]$cfgfile = '//--> Chocolatey-uBlock-Origin scope modification' +
                              'pref("extensions.autoDisableScopes", 11);'
         }
         Write-Debug "Writing '$cfgPath'."
         try { $cfg | out-file $cfgPath -Encoding ascii -Force }
         catch { throw "Error writing $cfgPath" }
      }
   } #end if 'AllUsers' and 'AutoEnable'

}