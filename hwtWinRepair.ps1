###########################################################################################################################################################
#Repair tool for windows
#Huntley Web Technologies scripting
#First script that will be used by users be nice
#Awesome lets roll
#Date: 11/30/2023 (Ver 0.001)
#
#Updates:
# 11/30/2023 - Included base fixes including sfc, dism, reregistering apps, check disk and reboot
#            - Created some dialog the user can follow and allowed for windows product name to be displayed
#            - Created colored to differentiate commands being ran
# 12/01/2023 - Added Product Name, Version and build number to display
#            - Allowed app reregistering to not show errors on the screen using -ErrorAction SilentlyContinue
###########################################################################################################################################################
Start-Transcript -Path C:\repairLog.txt -Append

Write-Host "Beginning base repair process"
Start-Sleep 2
Write-Host
Write-Host "Getting OS Information"
Write-Host "Windows Edition: " -NoNewline
$winedit = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ProductName).ProductName
$buildNum = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuildNumber).CurrentBuildNumber
$winVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion).DisplayVersion

if (($winedit -eq "Windows 10 Pro") -and ($buildNum -ge 22000)){

    Write-Host -ForegroundColor Green "Windows 11 Pro"
}
Elseif (($winedit -eq "Windows 10 Enterprise") -and ($buildNum -ge 22000)) {
    Write-Host -ForegroundColor Green "Windows 11 Enterprise"
}
Elseif (($winedit -eq "Windows 10 Home") -and ($buildNum -ge 22000)){
    Write-Host -ForegroundColor Green "Windows 11 Home"
}
Else {
    Write-Host -ForegroundColor Green $winedit
}
Write-Host "Windows Version: " -NoNewline
Write-Host -ForegroundColor Green $winVer
Write-Host "Windows Build Number: " -NoNewline
Write-Host -ForegroundColor Green $buildNum

Start-Sleep 2
Write-Host "Beginning System File Checker"
Write-Host
Start-Sleep 2
Write-Host "==================="
Write-Host -ForegroundColor Green "System File Checker"
Write-Host "==================="

sfc /scannow

Start-Sleep 2
Write-Host "SFC Completed"
Write-Host "Beginning OS Image Repair"
Write-Host
Start-Sleep 2
Write-Host "==============="
Write-Host -ForegroundColor Green "OS Image Repair"
Write-Host "==============="

dism /online /cleanup-image /restorehealth

Start-Sleep 2
Write-Host "DISM Complete"
Write-Host
Start-Sleep 2
Write-Host "=========================="
Write-Host -ForegroundColor Green "ReRegistering App Packages"
Write-Host "=========================="

Get-AppXPackage | Foreach {Add-appxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue} 

Start-Sleep 2
Write-Host "Beginning Disk Check (This will cause a reboot)"
Write-Host
Start-Sleep 2
Write-Host "=========="
Write-Host -ForegroundColor Green "Check Disk"
Write-Host "=========="

chkdsk C: /x /f /r

Start-Sleep 2
Write-Host "Rebooting and running Disk Check please refer to log file to see all results"
Start-Sleep 2
shutdown -r -t 0
