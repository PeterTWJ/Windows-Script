# Ensure script runs as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
    Write-Error "Run this script as Administrator!"
    exit
}

# Enable Server Manager at logon
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\ServerManager" -Name "DoNotOpenServerManagerAtLogon" -ErrorAction SilentlyContinue

# Enable all notifications
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 1

# Change Ethernet to Public
Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq "Private"} | Set-NetConnectionProfile -NetworkCategory Public

# Enable Task View button
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 1

# Show Search icon (value 2 = search box, 1 = icon, 0 = hidden)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 1

# Taskbar Alignment to Center (1)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 1

# Restore badges and taskbar flashing
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowBadges" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarFlashButton" -Value 1

# Allow shared windows indicator
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarShareIndicator" -Value 1

# Allow show desktop from far corner
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -ErrorAction SilentlyContinue

# Reset Start Layout (more pins)
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_Layout" -ErrorAction SilentlyContinue

# Show recent apps and recommendations
$startSettings = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $startSettings -Name "Start_TrackProgs" -Value 1
Set-ItemProperty -Path $startSettings -Name "Start_TrackDocs" -Value 1
Set-ItemProperty -Path $startSettings -Name "Start_Recommendations" -Value 1

# Re-enable account notifications
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ENABLED" -Value 1

# Enable Shutdown Event Tracker
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Reliability" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn" -Value 1

# Re-enable Ctrl+Alt+Del (if needed)
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableCAD" -Value 0

# Revert Password Policy (requires policy refresh or manual gpedit.msc)
secedit /export /cfg C:\secpol.cfg
(gc C:\secpol.cfg) -replace "PasswordComplexity = 0", "PasswordComplexity = 1" `
                  -replace "MaximumPasswordAge = 0", "MaximumPasswordAge = 42" | sc C:\secpol.cfg
secedit /configure /db C:\Windows\Security\Database\secedit.sdb /cfg C:\secpol.cfg /overwrite
Remove-Item C:\secpol.cfg

# Enable Lock Screen
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -ErrorAction SilentlyContinue

# Enable Do Not Disturb
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ENABLED" -Value 1

# Restore hidden icon menu (system tray)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 1

# Edge: Restore Microsoft experience settings
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Edge" -Name "PersonalizationReportingEnabled" -Value 1

# Reset ExtendedUIHoverTime to default (400 ms)
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "ExtendedUIHoverTime" -Value 400

Write-Output "System settings reverted. A reboot is recommended."