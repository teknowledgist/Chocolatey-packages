$ErrorActionPreference = 'Stop'  # stop on all errors

remove-item 'hklm:\software\classes\.hp2' -Force -ErrorAction silentlycontinue
remove-item 'hklm:\software\classes\.hpg' -Force -ErrorAction silentlycontinue
remove-item 'hklm:\software\classes\.hpgl' -Force -ErrorAction silentlycontinue
remove-item 'hklm:\software\classes\.plt' -Force -ErrorAction silentlycontinue
remove-item 'hklm:\software\classes\HPGLView' -Recurse -Force -ErrorAction silentlycontinue
