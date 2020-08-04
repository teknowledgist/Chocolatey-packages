$packageName = 'miktex.portable'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$linkName = "miktex-portable.lnk"

Function Get-RedirectedUrl {
   Param ([Parameter(Mandatory=$true)][String]$url)
 
   $request = [System.Net.WebRequest]::Create($url)
   $request.AllowAutoRedirect=$false
 
   try {
      $response=$request.GetResponse()
      $response.Headers["Location"]
      $response.Close()
   } catch {
      throw $_.Exception 
   }
}

$url = Get-RedirectedURL http://mirrors.ctan.org/systems/win32/miktex/setup/windows-x86/miktex-portable-2.9.6942.exe

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = $packageName
  checksum      = '20e42d52e7601f7b0abaf042408a18b39ffd84b3bb5c2a51f9b70a6555ea5897'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
$files = get-childitem $toolsDir -include *.exe -recurse

foreach ($file in $files) {
  #generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}

# start menu shortcut
$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutFilePath = Join-Path $programs $linkName 
$targetPath = Join-Path $toolsDir 'texmfs'
$targetPath = Join-Path $targetPath 'install'
$targetPath = Join-Path $targetPath 'miktex'
$targetPath = Join-Path $targetPath 'bin'
$targetPath = Join-Path $targetPath 'miktex-taskbar-icon.exe'
Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
