@echo off
title Run CCleaner
start /WAIT /d "C:\Program Files\CCleaner" CCleaner64.exe /AUTO

@echo off
title Check Disk 
echo y|chkdsk c: /f

@echo off
title Copy To Startup
copy "C:\Users\Tan\Desktop\Maintenance\Defrag.bat" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Defrag.bat"

@echo off
title Restart System
shutdown /r /t 00
exit
