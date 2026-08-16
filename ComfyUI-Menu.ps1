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
    Write-Host ""
    Write-Host "=== Running: $full ==="
    Write-Host ""
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

function Update-SecurityLevel {
    Invoke-Script (Join-Path 'Scripts' 'update_security_level.ps1')
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

function UnInstall-ComfyUI {
    Invoke-Script (Join-Path 'Scripts' 'cleanup.ps1')
    Wait-ForKey
}

function Backup-CustomNodes {
    Invoke-Script (Join-Path 'Scripts' 'backup-custom-nodes.ps1')
    Wait-ForKey
}

function Restore-CustomNodes {
    Invoke-Script (Join-Path 'Scripts' 'restore-custom-nodes.ps1')
    Wait-ForKey
}

function Install-Aria2c {
    Invoke-Script (Join-Path 'Scripts' 'install_aria2c.ps1')
    Wait-ForKey
}

function Download-LLM {
    Invoke-Script (Join-Path 'Scripts' 'download llm.ps1')
    Wait-ForKey
}

function Install-FFmpeg {
    Invoke-Script (Join-Path 'Scripts' 'install ffmpeg.ps1')
    Wait-ForKey
}

function Show-ToolsMenu {
    while ($true) {
        Clear-Host
        Write-Host "Tools - Select an action:`n"
        Write-Host "1) Install aria2c (portable)"
        Write-Host "2) Install FFmpeg"
        Write-Host "b) Back to main menu`n"

        $subchoice = [System.Console]::ReadKey($true).KeyChar

        switch ($subchoice) {
            '1' { Install-Aria2c }
            '2' { Install-FFmpeg }
            'b' { break }
            default { Show-InvalidSelection }
        }
    }
}

function Show-SetupMenu {
    while ($true) {
        Clear-Host
        Write-Host "Setup ComfyUI - Select an action:`n"
        Write-Host "1) Update ComfyUI"
        Write-Host "2) Setup (full install)"
        Write-Host "3) Uninstall ComfyUI"
        Write-Host "4) Backup Custom Nodes"
        Write-Host "5) Restore Custom Nodes"
        Write-Host "6) Update security level"
        Write-Host "b) Back to main menu`n"

        $subchoice = [System.Console]::ReadKey($true).KeyChar

        switch ($subchoice) {
            '1' { Install-All }
            '2' { Update-ComfyUi }
            '3' { Update-SecurityLevel }
            '4' { Backup-CustomNodes }
            '5' { Restore-CustomNodes }
            '6' { UnInstall-ComfyUI }
            'b' { break }
            default { Show-InvalidSelection }
        }
    }
}

while ($true) {
    Clear-Host
    Write-Host "ComfyUI Menu - Select an action:`n"
    Write-Host "1) Start ComfyUI"
    Write-Host "s) Setup ComfyUI"
    Write-Host "t) Tools"
    Write-Host "9) Download LLM"
    Write-Host "0) Exit`n"

    $choice = [System.Console]::ReadKey($true).KeyChar

    switch ($choice) {
        '1' { Start-ComfyUi }
        's' { Show-SetupMenu }
        't' { Show-ToolsMenu }
        '9' { Download-LLM }
        '0' { Exit-Process }
        default { Show-InvalidSelection }
    }
}

Write-Host "Exiting ComfyUI Menu..."
deactivate -nondestructive

