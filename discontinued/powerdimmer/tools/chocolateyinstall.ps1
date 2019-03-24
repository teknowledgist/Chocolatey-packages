$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

$installArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = Join-Path $env:SystemRoot 'system32'
}

Get-ChocolateyUnzip @installArgs
