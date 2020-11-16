$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

if (-not (Test-Path $fileLocation)) {
   Write-Warning 'Embedded ILLiad Client installer not found!'
   Write-Warning ("Client installers can be downloaded from:`n" +
                  'https://support.atlas-sys.com/hc/en-us/articles/360012037614-ILLiad-Downloads')
   Write-Warning 'The downloads are password protected, so this package must have them embedded.'
   Throw 'ILLiad Client installer is not embedded!'
}

# Extract the MSI bits for product code identification
$SetupArgs = @{
   Statements       = "/s /f2$env:Temp\TestLog.log /x /b$env:Temp"
   ExetoRun         = $fileLocation
   WorkingDirectory = $env:Temp
   validExitCodes   = @(-3)  # This "fail code" is expected here
}
$exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs

# Gather the product code for this version
if (Test-Path "$env:Temp\Setup.ini") {
   $Line = Get-Content "$env:Temp\Setup.ini" |
            Where-Object {$_ -match '^ProductCode='} | Select-Object -First 1
   $ProductCode = $Line.split('=')[1]
} else { Throw 'Test extraction failed.'}

if (${Env:ProgramFiles(x86)}) { $x86 = ' (x86)' } else {$x86 = ''}

$Components = @(
      'ILLiadClient',
      'StaffManager',
      'CustomizationManager',
      'ElectronicDeliveryUtility',
      'SAM',
      'BillingManager'
   )

$pp = Get-PackageParameters

# Customizing the components installation
if ($pp['Skip']) {
   $Skips = @($pp['Skip'].split(','))
   $Components = $Components | Where-Object {$Skips -notcontains $_}
}
$i = 0
$ComponentString = "Component-count=$($Components.count)"
Foreach ($Item in $Components) {
   $ComponentString += "`nComponent-$i=$Item"
   $i++
}

# InstallShield requires an answer file
$AnswerText = @"
[$($ProductCode)-DlgOrder]
Dlg0=$($ProductCode)-SdWelcome-0
Count=6
Dlg1=$($ProductCode)-SetupType2-0
Dlg2=$($ProductCode)-SdAskDestPath-0
Dlg3=$($ProductCode)-SdComponentTree-0
Dlg4=$($ProductCode)-SdStartCopy2-0
Dlg5=$($ProductCode)-SdFinish-0
[$($ProductCode)-SdWelcome-0]
Result=1
[$($ProductCode)-SetupType2-0]
Result=303
[$($ProductCode)-SdAskDestPath-0]
szDir=$($env:ProgramFiles + $x86)\ILLiad\
Result=1
[$($ProductCode)-SdComponentTree-0]
szDir=$($env:ProgramFiles + $x86)\ILLiad\
Component-type=string
$ComponentString
Result=1
[$($ProductCode)-SdStartCopy2-0]
Result=1
[$($ProductCode)-SdFinish-0]
Result=1
bOpt1=0
bOpt2=0
"@
$AnswerText | Out-File "$env:Temp\Answers.iss" -Force

# Finally! Install ILLiad silently (and with a log)
$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $fileLocation
   silentArgs     = "/s /f1$env:Temp\Answers.iss /v`"/l*v $env:Temp\MsiInstall.log`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
Remove-Item $fileLocation -ea 0 -force

if ($pp['NoIcons']) {
   $PubShortcuts = Get-ChildItem "$env:PUBLIC\Desktop" -Filter *.lnk
   foreach ($item in $PubShortcuts) {
      if ((New-Object -ComObject WScript.Shell).CreateShortcut($item.fullname).TargetPath -match 'illiad') {
         Remove-Item $Item.FullName -Force
      }
      if ($Item.Name -eq 'Atlas SQL Alias Manager.lnk') {
         # Only remove icon if it was just created.  (Other Atlas apps can install this.)
         if ($Item.creationtime.addminutes(1) -gt (get-date)) {
            remove-item $Item.FullName -Force
         }
      }
   }
} elseif ($pp['CleanIcons']) {
   # Reduce clutter on all user desktops that most can't remove
   $PubShortcuts = Get-ChildItem "$env:PUBLIC\Desktop" -Filter *.lnk
   if (-not (Test-Path "$env:PUBLIC\Desktop\ILLiad Tools")) {
      New-Item "$env:PUBLIC\Desktop\ILLiad Tools" -ItemType Directory -Force
   }
   foreach ($item in $PubShortcuts) {
      if ((New-Object -ComObject WScript.Shell).CreateShortcut($item.fullname).TargetPath -match 'illiad') {
         Move-Item $Item.FullName "$env:PUBLIC\Desktop\ILLiad Tools" -Force
      }
   }
}

if ($pp['DBCfile']) {
   function Set-DBCpath ($DBCfilePath = $pp['DBCfile'], $MRUpath) {
      if (Test-Path $MRUpath) {
         $DBClist = Get-Content $MRUpath
         if ($DBClist -notcontains $DBCfilePath) {
            $null = $DBCfilePath | Out-File $MRUpath -Append
         }
      } else {
         $null = New-Item $MRUpath -force
         $null = $DBCfilePath | Out-File $MRUpath -Force
      }
   }
   # Use an established DB connector file so users don't need to.
   $lnk = get-childitem 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\' -recurse -filter 'SQL Alias Manager.lnk'
   if ($lnk) {
      $SAMpath = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk.fullname).TargetPath
      $SAMversion = (Get-Item $SAMpath).VersionInfo.ProductVersion

      # In the default profile (for future users)
      $DefaultPath = "c:\users\default\AppData\Local\Atlas Systems, Inc\SqlAliasManager\$SAMversion\MRU.txt"
      Set-DBCpath -MRUpath $DefaultPath
      if ($pp['Default']) {
         if (${Env:ProgramFiles(x86)}) { $X = '\WOW6432Node' } else { $X = '' }
         $RegPath = "HKLM:\SOFTWARE$X\AtlasSystems\ILLiad"
         if (-not (Test-Path $RegPath)) { $null = New-Item $RegPath }
         $null = New-ItemProperty $RegPath -Name 'LogonSettingsPath' -Value $pp['DBCfile'] -Force
      }
      # Also set the current user's connector
      if ($env:USERNAME -ne "$env:computername`$") {
         $UserPath = $DefaultPath.replace('default',$env:USERNAME)
         Set-DBCpath -MRUpath $UserPath
      }
   } else {
      Write-Warning 'SQL Alias Manager not found!'
      Write-Warning 'The ILLiad DB connection will have to be established manually.'
   }
}

