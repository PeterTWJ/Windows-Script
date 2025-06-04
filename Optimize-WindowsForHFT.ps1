# Optimize-WindowsForHFT.ps1
# PowerShell script to optimize Windows for low-latency, high-determinism workloads (e.g., HFT)

# Requires: Run as Administrator

Write-Host "Setting power plan to Ultimate Performance..."
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61

Write-Host "Disabling Windows Defender (Real-time protection)..."
Set-MpPreference -DisableRealtimeMonitoring $true

Write-Host "Disabling Superfetch and Windows Search services..."
Stop-Service -Name "SysMain" -Force
Set-Service -Name "SysMain" -StartupType Disabled
Stop-Service -Name "WSearch" -Force
Set-Service -Name "WSearch" -StartupType Disabled

Write-Host "Setting processor scheduling to Background Services..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 18 /f

Write-Host "Disabling Windows Indexing..."
reg add "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f

Write-Host "Setting fixed pagefile (min/max 4096MB)..."
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096

Write-Host "Disabling Scheduled Tasks that introduce latency..."
Disable-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -TaskPath "\Microsoft\Windows\Application Experience\"
Disable-ScheduledTask -TaskName "ProgramDataUpdater" -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\"

Write-Host "Optimization complete. A reboot is recommended."
