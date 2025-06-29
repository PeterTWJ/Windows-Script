@echo off
title PerfectDisk
start /d "C:\Program Files\Raxco\PerfectDisk" PDCmd.exe /ssd c: /w
start /d "C:\Program Files\Raxco\PerfectDisk" PDCmd.exe /sp d: /w
start /d "C:\Program Files\Raxco\PerfectDisk" PDCmd.exe /cfs e: /w

@echo off
del "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Defrag.bat"
exit