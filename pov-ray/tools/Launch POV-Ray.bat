@echo off

:: This script was tested for POV-Ray v3.7 on Win7x64 where the files 
:: in the four, user-profile folders from the initial install have been
:: copied into the POV-Ray program folder.  It should work for Win8-10.

if exist "%userprofile%\Documents\POV-Ray\v3.7\include\colors.inc" goto _Launch

echo Initializing POV-Ray user configuration.

:: REG.EXE is often blocked, and WMIC is faster than PoSh.  See: https://stackoverflow.com/questions/22265482/registry-edit-from-batch
SET "HKCU=&H80000001"
SET KEY=Software\POV-Ray\v3.7\Windows
SET ValName=FreshInstall
SET Val=1
SET Success=Registry entry complete.
SET Fail=Registry entry failed. Viewing may work, but editor functions will not be available.
wmic.exe /NAMESPACE:\\root\default Class StdRegProv Call SetDWORDValue hDefKey="%HKCU%" sSubKeyName="%KEY%" sValueName="%ValName%" uValue="%Val%" > nul && echo %Success% || echo %Fail%

echo Copying user files...
echo Please be patient, this may take a minute.

SET "NUF=%ProgramFiles%\POV-Ray\v3.7\NewUserFiles"
robocopy "%NUF%" "%userprofile%\Documents\POV-Ray" /mir /NFL /NDL /NJH /nc /ns /np
IF %ERRORLEVEL% LSS 8 goto _Launch
echo Initializing failed.  POV-Ray is unlikely to work properly.
pause

:_Launch
shift
set params=%1
if [%1]==[] goto afterloop
:loop
shift
if [%1]==[] goto afterloop
set params=%params% %1
goto loop
:afterloop
start "Launching POV-Ray" "%ProgramFiles%\POV-Ray\v3.7\bin\pvengine64.exe" %params%