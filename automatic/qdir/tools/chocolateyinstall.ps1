$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ZipFiles = Get-ChildItem -Path $toolsDir -filter '*.zip' |
                  Sort-Object lastwritetime | Select-Object -Last 2 -ExpandProperty FullName

$UnZipArgs = @{
   packageName      = $env:ChocolateyPackageName
   FileFullPath     = $ZipFiles | Where-Object {$_ -notmatch 'x64'}
   FileFullPath64   = $ZipFiles | Where-Object {$_ -match 'x64'}
   Destination      = Join-Path $env:TEMP "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

$pp = Get-PackageParameters
if ($pp['Language']) { 
   $LanguageTable = @{
   'ar' = @('Arabic','25')
   'bg' = @('Bulgarian','32')
   'zh-CN' = @('Chinese (Simplified)',' 9')
   'zh-TW' = @('Chinese (Traditional)','5')
   'hr' = @('Croatian','23')
   'cs' = @('Czech','16')
   'da' = @('Danish','17')
   'nl' = @('Dutch','11')
   'en' = @('English','1')
   'en-GB' = @('English (UK)','28')
   'et' = @('Estonian','27')
   'fil' = @('Filipino','35')
   'fi' = @('Finnish','21')
   'fr' = @('French','2')
   'de' = @('German','0')
   'el' = @('Greek','13')
   'hu' = @('Hungarian','22')
   'id' = @('Indonesian','34')
   'it' = @('Italian','3')
   'ja' = @('Japanese','6')
   'ko' = @('Korean','7')
   'ms' = @('Malay','33')
   'nb' = @('Norsk (Bokmål)','29')
   'fa' = @('Persian','36')
   'pl' = @('Polish','8')
   'pt-BR' = @('Portuguese (Brazil)','18')
   'ro' = @('Romanian','19')
   'ru' = @('Russian','10')
   'sr' = @('Serbian','30')
   'sk' = @('Slovak','15')
   'sl' = @('Slovenian','24')
   'es' = @('Spanish','4')
   'es-AR' = @('Spanish (Argentinean)','14')
   'es-CO' = @('Spanish (Columbian)','31')
   'sv' = @('Swedish','20')
   'tr' = @('Turkish','12')
   'uk' = @('Ukrainian','26')
   }
   if ($LanguageTable."$($pp['Language'])") {
      $note = "Language code '{0}', '{1}' requested." -f $pp['Language'],$LanguageTable."$($pp['Language'])"[0]
      Write-Host $note -ForegroundColor Cyan
      $SilentArgs = "/silent admin nodesktop langid={0}" -f $LanguageTable."$($pp['Language'])"[1]
   } else {
      Throw "Language code '$($pp['Language'])' is not recognized."
   }
} else {
   Write-Verbose 'Default English language will be installed.'
   $SilentArgs = '/S admin nodesktop langid=1'
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName 
   fileType      = 'EXE'
   file          = (Get-ChildItem $UnZipArgs.Destination -Filter '*.exe' -Recurse).FullName
   file64        = (Get-ChildItem $UnZipArgs.Destination -Filter '*.exe' -Recurse).FullName
   silentArgs    = $SilentArgs
   validExitCodes= @(0,1)
}
Install-ChocolateyInstallPackage @InstallArgs
Remove-Item $UnZipArgs.Destination -Recurse -Force

$ZipFiles | ForEach-Object {Remove-Item $_ -Force}

# This allows Q-Dir to be called from the command line.
Install-BinFile -Name qdir -Path "$env:ProgramFiles\Q-Dir\Q-Dir.exe"

