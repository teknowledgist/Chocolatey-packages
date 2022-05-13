$ErrorActionPreference = 'Stop'; # stop on all errors

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = Get-ChildItem $ToolsDir -Filter "*.zip"

$UnzipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile.FullName
   Destination  = Join-Path $env:ChocolateyPackageFolder $ZipFile.BaseName
}
Get-ChocolateyUnzip @UnzipArgs

$targetpath = (Get-ChildItem $UnzipArgs.Destination -filter *.exe -Recurse).fullname
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'VOSviewer.lnk'

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath


# Check for a JavaSoft registry path for a compatible version.  
If (Test-Path 'HKLM:\SOFTWARE\JavaSoft\JRE') {
   $JRKversion = Get-ChildItem hklm:\SOFTWARE\JavaSoft\JRE -recurse |
                     ForEach-Object {if ($_.pschildname.split('.')[0] -match '^\d+$') {[int]($_.pschildname.split('.')[0])}} | 
                     Sort-Object | Select-Object -Last 1
   if ($JRKversion -gt 8) {
      Write-Verbose "JavaSoft registry key for version $JRKversion found."
   } else { $JavaVersion = $null }
}

# Check for a compatible version associated with the Java_Home environment variable.
if ($env:Java_Home) {
   if ((Test-Path $env:Java_Home) -and (Test-Path "$env:Java_Home\release")) {
      $VersionLine = Get-Content "$env:Java_Home\release" | Where-Object {$_ -match '^JAVA_VERSION="(1\.)?(\d+)'}
      if ($VersionLine) {
         $JEVversion = $matches[2]
         if ($JEVversion -ge 8) {
            Write-Verbose "Java_Home environment variable for version $JEVversion found."
         } else { $JEVversion = $null }
      }
   }
}

If (($JRKversion) -and ($JRKversion -ge $JEVversion)) {
   # JavaSoft registry key is good
   return
}

If (($JRKversion -lt $JEVversion) -and ($JEVversion)) {
   # When the JavaSoft registry key is missing or older than a valid Java_Home,
   #    Add a JavaSoft registry key so VOSviewer will run.
   $null = New-Item "HKLM:\SOFTWARE\JavaSoft\JRE\$JEVversion" -Force | 
            New-ItemProperty -Name JavaHome -Value $env:Java_Home -Force
   $Warning = 'JavaSoft registry key has been added to allow VOSviewer to start.'
   return
}

If ((-not $JRKversion) -and (-not $JEVversion)) {
   # If no (easily) apparent Java installed, warn but continue.
   $Warning = "VOSviewer requires JRE v8+ (and a JavaSoft registry entry).`n`tNo compatible Java installation was identified."
   return
}

