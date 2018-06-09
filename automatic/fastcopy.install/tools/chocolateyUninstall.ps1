# fastcopy.install really can't be uninstalled without AutoHotKey as a prereq.

$ProgDir = Join-Path $env:ProgramFiles 'FastCopy'

# silent uninstall requires AutoHotKey
$ahkFile = Join-Path $env:ChocolateyPackageFolder 'Tools\chocolateyUninstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Start-ChocolateyProcessAsAdmin -ExeToRun $(Join-Path $ProgDir 'setup.exe') -WorkingDirectory $ProgDir

# Uninstall leaves behind the DLL in use by explorer and sometimes other files
$DLLpath = (Get-ChildItem -Path $ProgDir -filter '*.dll').FullName
if (Test-Path $DLLpath) {
   $Lock = Get-Process | ForEach-Object { 
               $processVar = $_
               $_.Modules | ForEach-Object { 
                  if ($_.FileName -like "$DLLpath") { $processVar.Name }
               }
           }

   # Register a lock for deletion.
   If ($Lock) {
      Write-Host "The FastCopy file extension is locked by $Lock. The extension will be deleted on next reboot." -ForegroundColor Cyan
      # Function from: https://gallery.technet.microsoft.com/scriptcenter/Register-FileToDelete-0cbb00bb
      #   with the reference to "system.linq" removed as it is not needed here.
      Function Register-FileToDelete {
         [cmdletbinding(SupportsShouldProcess = $True )]
         Param (
            [parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
            [Alias('FullName','File','Folder')]
            $Source = 'C:\users\Administrator\desktop\test.txt'    
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

      Register-FileToDelete $DLLpath
      Register-FileToDelete $ProgDir

      # remove everything else
      Remove-Item (Join-Path $ProgDir '*.*') -Exclude $(Split-Path $DLLpath -Leaf) -Force
   } else {
      Remove-Item $ProgDir -Recurse -Force 
   }
} else {
   Write-Host 'FastCopy files appear to have already been deleted.' 
}
