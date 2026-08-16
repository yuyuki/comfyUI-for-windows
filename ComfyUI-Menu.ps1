# ComfyUI-Menu.ps1
# Simple PowerShell menu to launch repository tasks

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Wait-ForKey {
    Write-Host ""
    Write-Host "Press any key to continue..."
    $key = [System.Console]::ReadKey($true)
}

function Get-InstallScripts {
    $scriptsDir = Join-Path $scriptRoot 'Scripts'
    if (-not (Test-Path $scriptsDir)) { return @() }
    Get-ChildItem -Path $scriptsDir -Filter 'install*.ps1' -File -ErrorAction SilentlyContinue | Sort-Object Name
}

function Invoke-Script {
    param([string]$relativePath)
    $full = Join-Path $scriptRoot $relativePath
    if (-not (Test-Path $full)) {
        Write-Host "Script not found: $full" -ForegroundColor Yellow
        return
    }
    Write-Host "\n=== Running: $full ===\n"
    & $full
}

function Start-ComfyUi {
    Invoke-Script (Join-Path 'Scripts' 'start ComfyUI.ps1')
    Wait-ForKey
}

function Update-ComfyUi {
    Invoke-Script (Join-Path 'Scripts' 'UpdateComfyUI.ps1')
    Wait-ForKey
}

function Install-All {
    Invoke-Script (Join-Path 'Scripts' 'install.ps1')
    Wait-ForKey
}

function Show-InvalidSelection {
    Write-Host "Invalid selection" -ForegroundColor Red
    Wait-ForKey
}

function Exit-Process {
    Write-Host "Exiting ComfyUI Menu..."
    exit
}

function Cleanup {
    Invoke-Script (Join-Path 'Scripts' 'cleanup.ps1')
    Wait-ForKey
}

function Backup {
    Invoke-Script (Join-Path 'Scripts' 'backup-custom-nodes.ps1')
    Wait-ForKey
}

function Restore {
    Invoke-Script (Join-Path 'Scripts' 'restore-custom-nodes.ps1')
    Wait-ForKey
}

while ($true) {
    Clear-Host
    Write-Host "ComfyUI Menu - Select an action:`n"
    Write-Host "1) Start ComfyUI"
    Write-Host "2) Update ComfyUI"
    Write-Host "3) Setup"
    Write-Host "4) Cleanup"
    Write-Host "5) Backup"
    Write-Host "6) Restore"
    Write-Host "0) Exit`n"

    $choice = [System.Console]::ReadKey($true).KeyChar

    switch ($choice) {
        '1' { Start-ComfyUi }
        '2' { Update-ComfyUi }
        '3' { Install-All }
        '4' { Cleanup }
        '0' { Exit-Process }
        default { Show-InvalidSelection }
    }
}

Write-Host "Exiting ComfyUI Menu..."
deactivate -nondestructive

