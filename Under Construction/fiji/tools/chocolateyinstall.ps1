# This is stuck for now.
# Discussion:
#   https://github.com/imagej/imagej/issues/152
# Unresolved:
#   How to block automatic unpgrade check.
#   How to determine the currently installed version.
#   Update.ps1 not created
#      parse for info: http://maven.imagej.net/content/groups/public/net/imagej/imagej/maven-metadata.xml
#      Does Chocolatey nuspec support release candidate versioning?


$packageName = 'Fiji'
$version     = '2.0.0.5900'
$url         = 'http://downloads.imagej.net/fiji/latest/fiji-nojre.zip'
$checkSum    = 'A64D32E78A15B514B49D5E82651352BF65345A36B46F289952F4AAF0141E29C1'

$InstallDir = Join-Path $env:ProgramData $packageName

$InstallArgs = @{
   PackageName   = $packageName
   Url           = $url
   UnzipLocation = $InstallDir
   checkSum      = $checkSum
   checkSumType  = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$BitLevel = Get-ProcessorBits
$IJLauncher = Join-Path $InstallDir "Fiji.app\ImageJ-win$BitLevel.exe"

# javaw -Dpatch.ij1=false -Dpython.cachedir.skip=true -Dplugins.dir=C:\\PROGRA~3\\Fiji.app -Xmx3072m -Xincgc -XX:PermSize=128m -Djava.class.path=C:\\PROGRA~3\\Fiji.app/jars/imagej-launcher-4.0.5.jar -Dimagej.dir=C:\\PROGRA~3\\Fiji.app -Dij.dir=C:\\PROGRA~3\\Fiji.app -Dfiji.dir=C:\\PROGRA~3\\Fiji.app -Dfiji.defaultLibPath=bin/server/jvm.dll -Dfiji.executable=C:\\ProgramData\\Fiji.app\\ImageJ-win64.exe -Dij.executable=C:\\ProgramData\\Fiji.app\\ImageJ-win64.exe -Djava.library.path=C:\\PROGRA~3\\Fiji.app/lib/win64;C:\\PROGRA~3\\Fiji.app/mm/win64 -Dscijava.context.strict=false -Dscijava.log.level=info net.imagej.launcher.ClassLauncher -classpath . -ijjarpath jars -ijjarpath plugins net.imagej.updater.CommandLine update


# ImageJ/Fiji updates frequently and as pieces/plugins can update without the main program
#   being assigned a new version number (for Chocolatey to recognize). At this point in 
#   its development, Fiji is probably better off updating itself.  However, with a proper 
#   machine-level install, unprivileged users will not be able to update Fiji.
# The following will establish a scheduled task running as SYSTEM to have ImageJ/Fiji 
#   check for updates on a weekly basis.
$TaskName = "Update Fiji"
$TaskService = new-object -com("Schedule.Service")
$TaskService.connect()

if ((@($TaskService.getfolder("\").gettasks(1)) |select -expandproperty name) -icontains $TaskName) {
   $TaskService.getfolder("\").DeleteTask($TaskName,0)
}

$task_xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>$(get-date -Format yyyy-MM-ddTHH:MM:ss.00000)</Date>
    <Author>Chocolatey</Author>
    <Description>Periodically checks for updates to (Chocolatey-installed) Fiji.  If this task is disabled or removed, the instance of Fiji installed by Chocolatey will not automatically update.</Description>
  </RegistrationInfo>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>$(get-date -Format yyyy-MM-ddTHH:MM:00)</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>7</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <RunLevel>LeastPrivilege</RunLevel>
      <GroupId>NT AUTHORITY\SYSTEM</GroupId>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>StopExisting</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>true</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <UseUnifiedSchedulingEngine>false</UseUnifiedSchedulingEngine>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>9</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>cmd.exe</Command>
      <Arguments>/c "path=%path%;c:\programdata\oracle\java\javapath &#038; c:\programdata\Fiji.app\ImageJ-win64.exe --update update"</Arguments>
    </Exec>
  </Actions>
</Task>
"@

$Task = $TaskService.NewTask($null)
$task.XmlText = $task_xml

$TaskService.getfolder("\").RegisterTaskDefinition($TaskName, $Task, 6, $null, $null, 5) > $null

Write-Host 'Making sure installed version if fully patched.  Please be patient' -ForegroundColor Cyan
# ($TaskService.GetFolder("\").GetTasks(1) | ? {$_.name -eq $TaskName}).Run(0)
Write-Host 'If Java was just installed, future updates to Fiji may not occur until the computer is rebooted.' -ForegroundColor Cyan



$FijiLauncher = $IJLauncher -replace 'ImageJ','fiji'
$DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Fiji.lnk'
$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Fiji.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $FijiLauncher
Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $FijiLauncher
