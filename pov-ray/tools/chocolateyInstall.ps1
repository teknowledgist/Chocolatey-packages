$InstallArgs = @{
   packageName = 'pov-ray'
   installerType = 'exe'
   url = 'http://www.povray.org/redirect/www.povray.org/ftp/pub/povray/Official/povwin-3.7-agpl3-setup.exe'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

# POV-ray installs for the current user, but completely ignores future, other users.
# This will copy all the files that the installing user gets (including some
# necessary ones) to the Default user profile.  This measurably slows down initial
# logins, but there is no mechanism to always have these files created for users upon
# their first run of POV-ray (usually called from another app) nor is there any means
# to include these files for already-existing user profiles.  

$InstallArgs2 = @{
   packageName = "POV-Ray Editor"
   installerType = 'exe'
   url = 'http://www.povray.org/download/povwin-3.7-editor.exe'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs2

Write-Output "Copying libraries and settings..."
copy-item "$env:USERPROFILE\Documents\POV-Ray" "$env:USERPROFILE\..\default\documents" -recurse
copy-item "$env:USERPROFILE\Documents\POV-Ray" "$env:ProgramFiles\POV-Ray\v3.7\default documents" -recurse
