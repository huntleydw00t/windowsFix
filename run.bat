@Echo off
PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0\hwtWinRepair.ps1"' -Verb RunAs}"