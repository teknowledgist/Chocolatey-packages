$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerPath = (Get-ChildItem -Path $toolsDir -filter '*.exe').FullName

if (-not $InstallerPath) {
   $ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName
   Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination $toolsDir
   $InstallerPath = (Get-ChildItem -Path $toolsDir -filter '*.exe').FullName
}

$ProgDir = Join-Path $env:ProgramFiles 'FastCopy'

$UninstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $InstallerPath
   silentArgs     = "/silent /r"
   validExitCodes = @(0)
}
Uninstall-ChocolateyPackage @UninstallArgs

$Shortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\FastCopy.lnk"
if (Test-Path $Shortcut) {
   Remove-Item $Shortcut -Force
}

# Uninstall often leaves behind the DLL in use by explorer and sometimes other files
if (Test-Path (Join-Path $env:ProgramFiles 'FastCopy\*')) {
   [array]$Locks = Get-Process | ForEach-Object { 
               $processVar = $_
               $_.Modules | ForEach-Object { 
                  if ($_.FileName -like "*fastcopy*.dll") { $_.FileName }
               }
           } | Select-Object -Unique

   # Register a lock for deletion.
   If ($Locks) {
      Write-Host "A FastCopy file, $Locks, is locked. The extension will be deleted on next reboot." -ForegroundColor Cyan
      # Function from: https://gallery.technet.microsoft.com/scriptcenter/Register-FileToDelete-0cbb00bb
      #   with the reference to "system.linq" removed as it is not needed here.
      Function Register-FileToDelete {
         [cmdletbinding(SupportsShouldProcess = $True )]
         Param (
            [parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
            [Alias('FullName','File','Folder')]
            $Source = "$env:TEMP\test.dll"    
         )
         Begin {
            Try { $null = [File] } 
            Catch { 
               Write-Verbose 'Compiling code to create type'   
               Add-Type @'
               using System;
               using System.Collections.Generic;
               using System.Text;
               using System.Runtime.InteropServices;
        
               public class Posh
               {
                   public enum MoveFileFlags
                   {
                       MOVEFILE_REPLACE_EXISTING           = 0x00000001,
                       MOVEFILE_COPY_ALLOWED               = 0x00000002,
                       MOVEFILE_DELAY_UNTIL_REBOOT         = 0x00000004,
                       MOVEFILE_WRITE_THROUGH              = 0x00000008,
                       MOVEFILE_CREATE_HARDLINK            = 0x00000010,
                       MOVEFILE_FAIL_IF_NOT_TRACKABLE      = 0x00000020
                   }

                   [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
                   static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);
                   public static bool MarkFileDelete (string sourcefile)
                   {
                       bool brc = false;
                       brc = MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);          
                       return brc;
                   }
               }
'@
            }
         }
         Process {
            ForEach ($item in $Source) {
               Write-Verbose ('Attempting to resolve {0} to full path if not already' -f $item)
               $item = (Resolve-Path -Path $item).ProviderPath
               If ($PSCmdlet.ShouldProcess($item,'Mark for deletion')) {
                   If (-NOT [Posh]::MarkFileDelete($item)) {
                       Try { Throw (New-Object System.ComponentModel.Win32Exception) }
                       Catch {Write-Warning $_.Exception.Message}
                   }
               }
            }
         }
      } #end Register-FileToDelete function

      Foreach ($Lock in $Locks) {
         if (Test-Path $Lock) { Register-FileToDelete $Lock }
      }
      Register-FileToDelete $ProgDir

      # remove everything else
      Remove-Item (Join-Path $ProgDir '*.*') -Force -ErrorAction SilentlyContinue
   } else { Remove-Item $ProgDir -Recurse -Force }
} else { Write-Host 'FastCopy files appear to have been fully deleted.' }
