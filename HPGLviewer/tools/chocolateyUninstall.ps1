if (test-path (Join-Path $env:ProgramFiles 'HpglView')) {
   Remove-Item (Join-Path $env:ProgramFiles 'HpglView') -Recurse -Force
}

remove-item 'hklm:\software\classes\.hp2'
remove-item 'hklm:\software\classes\.hpg'
remove-item 'hklm:\software\classes\.hpgl'
remove-item 'hklm:\software\classes\.plt'
remove-item 'hklm:\software\classes\HPGLView' -Recurse -Force
