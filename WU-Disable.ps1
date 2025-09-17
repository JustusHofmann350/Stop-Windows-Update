# Copyright (c) 2025 Justus Hofmann

param (
    [switch]$Enable,
    [switch]$Disable
)

$ErrorActionPreference = 'Stop'

function Enable-Updates {
    # Rename back to original name
    Write-Host "Enabling updates..."
    Rename-Item HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv-BLOCKED!! -NewName wuauserv
    if (Test-Path HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv){
        Write-Host "Successfully enabled updates."
        Write-Host "nRestart your Computer for the changes to take effect. DO NOT shutdown or use the power button. A restart is needed."
    }
    else {
        Write-Host "Error occured. Try again or check the README"
    }
}

function Disable-Updates {
    # Backup registry
    Write-Host "Disabling updates...`n"
    try {
        Write-Host "    Backing up registry..."
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services"
        $outputFile = Join-Path $PSScriptRoot $regPath

        reg export "$regPath" "$outputFile" /y
        Write-Host "        Backed up $regPath to: $outputFIle"
    }
    catch {
        Write-Host $_
        Write-Host "        Script execution stopped due to failed registry backup."
        Break
    }

    # Rename wuauserv and WaaSMedicSvc in order to disable Updates
    Write-Host "    Renaming wuauserv and WaaSMedicSvc..."
    Rename-Item HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv -NewName wuauserv-BLOCKED!!
    Rename-Item HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc -NewName WaaSMedicSvc-BLOCKED!!
    if (Test-Path HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv-BLOCKED!! -and Test-Path HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc-BLOCKED!!){
        Write-Host "Successfully disabled Windows updates."
        Write-Host "`nTo Enable updates again run: WU-Disable.ps1 -Enable"
    }
    else {
        Write-Host "Error occured. Try again or check the README"
    }
}

if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-Host "You need to run this script as an Administrator!"
    Break
}

if (-not $Enable -and -not $Disable) {
    Write-Error "You must specify either -Enable or -Disable."
    exit 1
}

if ($Enable -and $Disable) {
    Write-Error "You cannot specify both -Enable and -Disable."
    exit 1
}

if ($Enable) {
    Enable-Updates
}

if ($Disable) {
    Disable-Updates
}