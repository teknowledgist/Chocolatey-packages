$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous, unzipped "installs"
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" -Directory
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFiles = Get-ChildItem $toolsDir -filter '*.zip' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFiles | Where-Object {$_.basename -match 'x86'} | Select-Object -ExpandProperty fullname
   FileFullPath64 = $ZipFiles | Where-Object {$_.basename -match 'x64'} | Select-Object -ExpandProperty fullname
   Destination    = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

$ZipFiles | ForEach-Object { Remove-Item $_.fullname -Force }

$EXE = Get-ChildItem $UnzipArgs.Destination -filter 'rpgmap.exe' -Recurse
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\RPG Map Editor 2.lnk'
   TargetPath       = $EXE.FullName
   IconLocation     = Join-Path $toolsDir "RPG Map Editor 2.ico"
   WorkingDirectory = $EXE.Directory.FullName
}
Install-ChocolateyShortcut @ShortcutArgs

$EXEs = Get-ChildItem $UnzipArgs.Destination *.exe -Recurse
foreach ($exe in $exes) {
   $null = New-Item "$($exe.fullname).ignore" -Type file -Force
}

# The following is required to prevent a UAC prompt on first start.
$UserSettings = New-Item -Path $EXE.Directory.FullName -Name 'UserSettings' -ItemType Directory

$DefaultFiles = @{
   export   = 'oy8:contrastfy11:disableGridfy8:fileNamey5:Imagey6:formatwy17:ImageOutputFormaty3:Png:0y8:presetIdny5:scalei1y9:showIconsty10:showLabelsty10:showRulersfg'
   help     = 'oy5:donesahg'
   imageLib = 'oy6:imagesahg'
   map      = '{"collisions":[],"furnDepth":{"id":0,"p":[]},"grounds":[],"h":40,"icons":[],"labels":[],"legend":{"x":0,"y":0},"lights":[],"mobs":[],"objects":[],"pools":[],"skin":{"base":{"walls":13530947,"windows":6809278,"wallOutline":null,"doors":15233090,"bg":5715237,"dirt":11562056,"furn":13403491,"appBg":1052441,"stairs":-1998203707,"colorless":false,"fences":11588072,"shadows":425148975},"bubbleSkin":{"id":0,"p":[]},"fogColor":2433347,"fogIntensity":0,"grid":{"id":3,"p":[]},"gridColor":16777215,"gridDepth":{"id":0,"p":[]},"gridIntensity":0.2,"plant1":6270751,"plant2":6270751,"printerFriendly":false,"seed":313283,"specialWater1":16733696,"specialWater2":9478433,"teint":null,"water":6657005},"snapFurnToWalls":true,"version":10,"w":40}'
   settings = 'oy19:advancedMapSettingsfy9:debugModefy16:delayLightRenderty16:fileButtonLabelsfy10:fullScreenty11:helpStartupty4:langy2:eny11:lastMapPathny17:lastVersionNumberzy12:lightQualitywy12:LightQualityy6:Medium:0y17:mouseWheelZoomSpdd0.5y11:newMapWallsfy9:newMapWidi40y14:panWarningDonefy11:recentFilesahy11:showHelpBarty14:toolBarColumnsi3y11:zoomButtonstg'
}
foreach ($key in $DefaultFiles.Keys) {
   # Must avoid the BOM, so Out-File can't work.
   $null = New-Item "$UserSettings\rpgMap_$key" -Value $DefaultFiles.$key
}