# Ensure script runs as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
    Write-Error "Run this script as Administrator!"
    exit
}

# Do not display Server Manager at logon
Set-ItemProperty -Path "HKLM:\Software\Microsoft\ServerManager" -Name "DoNotOpenServerManagerAtLogon" -Value 1 -Type DWord

# Turn off all notifications
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 0 -Type DWord

# Change Ethernet to Private Network
Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq "Public"} | Set-NetConnectionProfile -NetworkCategory Private

# Taskbar: Disable Task View
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

# Hide Search icon
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

# Taskbar Alignment to Left (0 = Left, 1 = Center)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0

# Unpin all taskbar items
$taskbarPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
Remove-Item "$taskbarPath\*" -Force -ErrorAction SilentlyContinue

# Hide taskbar badges and flashing
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowBadges" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarFlashButton" -Value 0

# Unshare windows on taskbar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarShareIndicator" -Value 0

# Unselect far corner of taskbar to show desktop
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 1

# Combine taskbar buttons and hide labels (0 = Always combine)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 0

# Layout: More pins (Start layout)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_Layout" -Value 1

# Uncheck show recently added apps and other recommendations
$startSettings = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $startSettings -Name "Start_TrackProgs" -Value 0
Set-ItemProperty -Path $startSettings -Name "Start_TrackDocs" -Value 0
Set-ItemProperty -Path $startSettings -Name "Start_Recommendations" -Value 0

# Disable account-related notifications
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ENABLED" -Value 0

# Disable Shutdown Event Tracker
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn" -Value 0 -Force

# Disable Ctrl+Alt+Delete options (e.g., disable Change Password)
$regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
New-ItemProperty -Path $regPath -Name "DisableCAD" -PropertyType DWord -Value 1 -Force

# Disable Strong Password Enforcement + Password Restrictions
secedit /export /cfg C:\secpol.cfg
(gc C:\secpol.cfg) -replace "PasswordComplexity = 1", "PasswordComplexity = 0" `
                  -replace "MaximumPasswordAge = \d+", "MaximumPasswordAge = 0" | sc C:\secpol.cfg
secedit /configure /db C:\Windows\Security\Database\secedit.sdb /cfg C:\secpol.cfg /overwrite
Remove-Item C:\secpol.cfg

# Turn on DEP for Windows programs and services only
bcdedit /set {current} nx OptIn

# Disable Lock Screen
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Value 1

# Turn off Do Not Disturb (Focus Assist)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ENABLED" -Value 0

# Hide hidden icon menu (system tray overflow)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0

# Edge: Disable Microsoft experience prompt
$edgeExp = "HKCU:\Software\Policies\Microsoft\Edge"
New-Item -Path $edgeExp -Force | Out-Null
Set-ItemProperty -Path $edgeExp -Name "PersonalizationReportingEnabled" -Value 0

# ExtendedUIHoverTime: Set to 60 seconds (60000 ms)
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "ExtendedUIHoverTime" -Value 60000

Write-Output "System tuning complete. A reboot may be required for all changes to apply."