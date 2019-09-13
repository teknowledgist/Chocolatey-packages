$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition

$publicFunctions = @(
   'Install-ChocolateyFont',
   'Uninstall-ChocolateyFont'
)

$publicAliases = @(
   'Add-Font',
   'Remove-Font'
)

Get-ChildItem -Path "$scriptRoot\*.ps1" | ForEach-Object { . $_ }
Export-ModuleMember -Function $publicFunctions -Alias $publicAliases
