function Suspend-ChocolateyInstallerURLs {
   <#
   .SYNOPSIS
   Prevents HTTP or HTTPS calls to the default browser for URLs 
   matching a regular expression.

   .DESCRIPTION
   This function will attempt prevent Windows from opening URLs in
   the user-defined, default web browser which are often the result
   of an application installer or uninstaller and can make a package
   be flagged as "not-silent".  All blocked URLs are logged and those
   not matching a provided regular expression can be opened by a
   subsequent call to Restore-ChocolateyInstallerURLs.

   .NOTES
   Be sure to call Suspend-ChocolateyInstallerURLs and Restore-
   ChocolateyInstallerURLs sandwiched around a Try-Catch statement
   with the <action>-ChocolateyPackage call.  Otherwise, if the
   install/uninstall fails, future calls to HTTP/HTTPS will only
   be logged and not open for the user.

   .PARAMETER PackageName
   A name for tracking purposes.  Use the same name for
   Suspend-ChocolateyInstallerURLs and Restore-ChocolateyInstallerURLs.

   .PARAMETER Protocol
   Protocol to capture.  Must be 'HTTP' (default), 'HTTPS', or 'both'.

   .EXAMPLE
   Suspend-ChocolateyInstallerURLs -PackageName 'xplorer2'
   try {
   Uninstall-ChocolateyPackage @PackageArgs
   Restore-ChocolateyInstallerURLs -PackageName 'xplorer2' -regex 'zabkat.*uninst'
   } Catch {Restore-ChocolateyInstallerURLs -PackageName 'xplorer2'}

   #>
   [CmdletBinding()]
   param(
      [parameter(Position=0)][string] $PackageName = $env:ChocolateyPackageName,
      [parameter][String[]] $Protocol = 'http'
   )



# This is one possible method of capturing URLs.  It uses the "debug" method
#   similar to how Notepad2 replaces Notepad.  The process works for
#   "regular" browsers for all Windows in that an EXE can be called in 
#   place of another.  However, the extended command switches for 
#   cmd.exe appear to not work.
$HTTPDefault = (Get-ItemProperty 'registry::HKEY_CLASSES_ROOT\http\shell\open\command').'(default)' -replace '^.*\\(.*?\.exe)".*','$1'

$RedirectKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$HTTPDefault"
$RedirectCommand = '"c:\windows\system32\cmd.exe" /c echo > "' + (Join-Path $WorkingFolder 'CapturedCall.txt') + '"'
$exists = Test-Path $RedirectKey
if (-not $exists) {
   New-Item $RedirectKey -Force | Write-Debug
} 
   New-ItemProperty -Path $RedirectKey -Name "Debugger" -Value $RedirectCommand -Force | Write-Debug

Install-ChocolateyPackage @InstallArgs

if (-not $exists) {
   Remove-Item $RedirectKey -Recurse
} else {
   Remove-ItemProperty -Path $RedirectKey -Name 'Debugger' -Force
}



# This method only works in Win7 because Win10 has protected default applications
#   with a "secret" hash (see: https://kolbi.cz/blog/?p=346).
$Protocols = 'http','https'
$ToRemove = @{}
$UserChoice = @{}
foreach ($p in $Protocols) {
   $UserChoiceKey = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\$p\UserChoice"
   if (Test-Path $UserChoiceKey) {
      # Collect the user's default http(s) handler(s)
      $UserChoice.$p = (Get-ItemProperty $UserChoiceKey).progid
   }
   else {
      # If the user hasn't set a default, create the default keys
      $KeyPath = 'HKCU:\Software\Microsoft\Windows\Shell\Associations'
      if (-not (Test-Path $KeyPath)) {
         $null = New-Item $KeyPath -Force
         if (-not $ToRemove.$p) {$ToRemove.$p += $KeyPath}
      }
      $KeyPath += '\UrlAssociations'
      if (-not (Test-Path $KeyPath)) {
         $null = New-Item $KeyPath -Force
         if (-not $ToRemove.$p) {$ToRemove.$p += $KeyPath}
      }
      $KeyPath += "\$p"
      if (-not (Test-Path $KeyPath)) {
         $null = New-Item $KeyPath -Force
         if (-not $ToRemove.$p) {$ToRemove.$p += $KeyPath}
      }
      $KeyPath += '\UserChoice'
      if (-not (Test-Path $KeyPath)) {
         $null = New-Item $KeyPath -Force
         if (-not $ToRemove.$p) {$ToRemove.$p += $KeyPath}
      }
   }
   # Now set the default handler
   Set-ItemProperty $UserChoiceKey -Name 'progid' -Value 'ChocoURLCapture' -Force
}

# Create the default handler information
$CaptureKey = 'HKCU:\Software\Classes\ChocoURLCapture'
New-Item $CaptureKey  -Force
New-Item "$CaptureKey\Shell" -Value 'open' -Force
New-Item "$CaptureKey\Shell\open" -Force
New-Item "$CaptureKey\Shell\open\command" -Value "cmd.exe /u /d /c `"echo %1 >>$env:Temp\ChocolateyBlockedURLs.txt`"" -Force

try {
   Install-ChocolateyPackage @InstallArgs
}
catch {
   
}
Finally {
   foreach ($p in $Protocols) {
      if ($UserChoice.$p) {
         Set-ItemProperty $UserChoiceKey -Name 'progid' -Value $UserChoice.$p -Force
      } else {
         $null = Remove-Item $ToRemove.$p -Recurse -Force
      }
   }
   $null = Remove-Item $CaptureKey -Recurse -Force
}






}

Set-Alias -Name Block-InstallerURLs




