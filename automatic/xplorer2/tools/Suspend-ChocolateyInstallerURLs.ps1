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

   #Get the value from here
   $userchoice = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice'
   $UCkey = 'progid'
   
   # save it and set the value to ChocoURLCapture

   #Then create the registry keys
   $regstring = @'
[HKEY_CURRENT_USER\Software\Classes\ChocoURLCapture\Shell]
@="open"

[HKEY_CURRENT_USER\Software\Classes\ChocoURLCapture\Shell\open]

[HKEY_CURRENT_USER\Software\Classes\ChocoURLCapture\Shell\open\command]
@="cmd.exe /u /d /c "echo %1 >c:\users\master\desktop\urls.txt""
'@


}

Set-Alias -Name Block-InstallerURLs
