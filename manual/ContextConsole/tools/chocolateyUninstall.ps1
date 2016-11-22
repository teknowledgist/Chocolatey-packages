try {
   & C:\Windows\System32\regsvr32.exe /u /i /s /n 'C:\Windows\system32\ShellExt\CmdOpen.dll'

   if (Get-ProcessorBits -eq 64) {
      & C:\Windows\SysWOW64\regsvr32.exe /u /i /s /n 'C:\Windows\system32\ShellExt\CmdOpen.dll'
   }
}
catch {
   throw 'ContextConsole not fully removed'
}