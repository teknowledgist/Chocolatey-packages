$ErrorActionPreference = 'Stop'

# The installer doesn't remove previous versions, so there could be multiple "installs"
$InstallDirs = Get-ChildItem $env:ChocolateyPackageFolder | 
                  Where-Object {($_.psiscontainer) -and ($_.name -match $env:ChocolateyPackageName)}

# Delete all Start Menu links associated with OpenCrom
foreach ($Dir in $InstallDirs) {
   $lnk = $Dir.Name -replace $env:ChocolateyPackageName,"$env:ChocolateyPackageName v"
   $StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\$lnk.lnk"

   if(Test-Path $StartShortcut) {
      Remove-Item $StartShortcut -Force
   }

   # Some files end up with paths > 256 characters and deletion fails.
   # Rename offensively long folders to fix this.
   Get-ChildItem (Join-Path $Dir.FullName "plugins") | 
            Where-Object{($_.psiscontainer) -and ($_.name.Length -gt 25)} |
            ForEach-Object {Rename-Item $_.FullName (get-random -max 10000) -Force}

   $null = Remove-Item $Dir.fullname -Recurse -Force
}


