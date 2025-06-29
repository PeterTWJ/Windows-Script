@echo off

:: Run CCleaner if installed
set "CCLEANER_PATH=%ProgramFiles%\CCleaner\CCleaner64.exe"
if exist "%CCLEANER_PATH%" (
    title Run CCleaner
    start /WAIT "" "%CCLEANER_PATH%" /AUTO
) else (
    echo CCleaner not found at "%CCLEANER_PATH%". Skipping.
)

:: Run Check Disk
title Check Disk
echo y | chkdsk C: /F

:: Copy Defrag.bat to Startup folder
title Copy To Startup
set "USERPROFILE_PATH=%USERPROFILE%\Desktop\Maintenance\Defrag.bat"
if exist "%USERPROFILE_PATH%" (
    copy "%USERPROFILE_PATH%" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Defrag.bat" /Y
) else (
    echo Defrag.bat not found at %USERPROFILE_PATH%. Skipping.
)

:: Restart System
title Restart System
shutdown /r /t 0
exit
