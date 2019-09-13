<#
.SYNOPSIS
   Uninstalls a font or set of fonts.

.DESCRIPTION
   This function deletes fonts from the system Fonts folder, removes the font 
   registry keys and removes the font resources.  
  
   It only works with FNT, FON, OTF, TTC, TTF fonts.

   By default, it accepts only a single font file, but the -multiple
   switch allows it to accept a list of font file names where it will 
   attempt to uninstall all of them.

.EXAMPLE
   Uninstalls a single font
      PS C:\> Uninstall-ChocolateyFont "FontName.ext"

.EXAMPLE
   Uninstalls all fonts contained in a list of file paths
      PS C:\> Uninstall-ChocolateyFont $ListOfFontFiles -multi

.INPUTS
   A string or array of strings of names of font files (including extensions)
   in the System Fonts folder.

.OUTPUTS
   Default:  "0" for success, "1" for failure
   With -multiple switch:  The number of fonts successfully uninstalled.

.NOTES
   Aliased as Remove-Font.
#>
function Uninstall-ChocolateyFont { 
   param(
      [Parameter(Mandatory=$true)][string[]]$FontFiles,
      [Parameter(Mandatory=$false)][switch]$Multiple=$false
   )
   
   # Establish some basic starting points
   $successes = 0
   $FontsFolder = (New-Object -ComObject Shell.Application).namespace(0x14).self.path
   $fontRegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
   $FontFileTypes = @('.fon','.fnt','.ttf','.ttc','.otf')

   New-FontResourceType

   if ((-not $Multiple) -and ($FontFiles.count -gt 1)) {
      Throw "The '-multiple' switch must be used to install more than a single font."
   }

   # Get installed font names and filenames
   $FontKeyProperties = (Get-ItemProperty $fontRegistryPath).PsObject.Properties | 
                           Where-Object {$_.value -match "(\$($fontfiletypes -join '|\'))`$"}

   foreach ($Item in $FontFiles) {
      # Skip non-supported file types
      If (-not $FontFileTypes -contains ".$($Item.split('.')[-1])") { 
         Write-Warning "'$Item' is not a file of type $($FontFileTypes -join ', ')."
         continue
      }
      # Skip non-existant files
      $FontPath = Join-Path $FontsFolder $Item
      If (-not (Test-Path $FontPath)) {
         Write-Warning "File Path '$FontPath' does not exist!"
         continue
      }
      $File = Get-Item $FontPath

      foreach($property in $FontKeyProperties) {
         if($Item -eq $property.Value) {
            $FontName = $property.Name
            break
         }
      }

      try {
         $retVal = [FontResource.AddRemoveFonts]::RemoveFont($FontPath)
         if ($retVal -eq 0) {
            Throw "Font resource, '$FontPath', removal failed"
         } else {
            Write-Verbose "Font resource, '$($File.FullName)', removed successfully"
            Remove-ItemProperty -Path $fontRegistryPath -Name "$FontName" -Force
            Remove-Item $FontPath -Force
            $successes++
         }
      }
      catch
      {
         Write-Warning "An error occured removing '$Item'."
         Write-Warning "$($error[0].ToString())"
         $error.clear()
      }
   }
   
   If ($Multiple) {
      Return $successes
   } elseif ($successes) {
      Return 0
   } else {
      Return 1
   }
}

Set-Alias Remove-Font Uninstall-ChocolateyFont
