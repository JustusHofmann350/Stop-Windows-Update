# Copyright (c) 2025 Justus Hofmann
$ErrorActionPreference = 'SilentlyContinue'

if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-Host "You need to run this script as an Administrator!"
    Break
}

param (
    [Parameter(Mandatory = $true, ParameterSetName = "EnableUpdates")]
    [switch]$Enable,

    [Parameter(Mandatory = $true, ParameterSetName = "DisableUpdates")]
    [switch]$Disable
)


if ($Enable) {
    Enable-Updates
}
elseif ($Disable) {
    Disable-Updates
}

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
    
    

