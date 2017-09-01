$ErrorActionPreference = 'Stop'

$packageName   = 'idl-envi'
$NameMatch     = 'IDL*ENVI*'
$Version       = '5.3.1.0'
$Share         = '\\Server\Share'           # The software deployment share path
$FileName      = 'IDL_ENVI53SP1win64.exe'   # The .exe installer
$AnswerFile    = 'SilentSetup.iss'          # The InstallShield answer file in the Tools folder and created by you!
$LicenseServer = '1700@licenses.x.org'    # The port@server hosting the network license

[array]$keys = Get-UninstallRegistryKey -SoftwareName $NameMatch
foreach ($key in $keys) {
   If ($key.DisplayVersion -eq $Version) {
      Write-Host "$packageName package version $Version already installed."
      return
   }
}

$unzipArgs = @{
   FileFullPath64 = Join-Path $Share $FileName
   Destination    = Join-Path $env:TEMP $packageName
   PackageName    = $packageName
}
Get-ChocolateyUnzip @unzipArgs

$installScript = Join-Path (Split-Path $MyInvocation.MyCommand.Definition) $AnswerFile

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  file64         = Join-Path $env:TEMP "$packageName\setup64.exe"
  softwareName   = $NameMatch
  silentArgs     = "/s /sms /f1$installScript"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs

# The environment variable that defines where to look for a license
$VarArgs = @{
   VariableName  = 'LM_LICENSE_FILE'
   VariableValue = $LicenseServer
   VariableType  = 'Machine'
}
Install-ChocolateyEnvironmentVariable @VarArgs

# The firewall exception (so unprivileged users don't get harrassed)
# https://www.ucunleashed.com/1366
[object]$Firewall = New-Object -ComObject hnetcfg.fwpolicy2 
[object]$rule = New-Object -ComObject HNetCfg.FWRule
$rule.Name = $packageName
$rule.ApplicationName = Join-Path $env:ProgramFiles '\exelis\idl85\bin\bin.x86_64\envi_idl.exe'
$rule.Protocol = 256
$rule.Enabled = $true
$rule.Profiles = 7
$rule.EdgeTraversal = $false
$rule.description = "This rule created by the idl-envi Chocolatey package installer."
$Firewall.Rules.Add($rule)

