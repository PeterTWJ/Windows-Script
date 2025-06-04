# Optimize-WindowsForHFT.ps1

A PowerShell script to configure a Windows system for low-latency, deterministic performance suitable for High-Frequency Trading (HFT) workloads.

## 🔧 What It Does
- Enables **Ultimate Performance** power plan
- Disables **Windows Defender real-time protection**
- Disables **Superfetch** (SysMain) and **Windows Search Indexing**
- Adjusts processor scheduling for **I/O priority**
- Sets a **fixed pagefile size** (4GB)
- Disables scheduled tasks that generate background load

## ⚠️ Warnings
- Requires **administrator privileges**
- May reduce security (e.g., disables Defender)
- Reboot is recommended after applying changes

## 🚀 Usage
```powershell
Run PowerShell as Administrator:
Set-ExecutionPolicy RemoteSigned
./Optimize-WindowsForHFT.ps1
```

## 🧪 Tested On
- Windows Server 2022
- Windows 11 Pro
