# First load the functions that the dependency (i.e. ".install") package uses
. "$((pwd).path -replace 'portable','install')\update.ps1"


update -ChecksumFor none