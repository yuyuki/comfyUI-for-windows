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
            'b' { return }
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
        Write-Host "7) Fix NVML DLL location (copy System32\nvml.dll to Program Files NVSMI)"
        Write-Host "b) Back to main menu`n"

        $subchoice = [System.Console]::ReadKey($true).KeyChar

        switch ($subchoice) {
            '1' { Install-All }
            '2' { Update-ComfyUi }
            '3' { Update-SecurityLevel }
            '4' { Backup-CustomNodes }
            '5' { Restore-CustomNodes }
            '6' { UnInstall-ComfyUI }
            '7' { Invoke-Script (Join-Path 'Scripts' 'fix_nvml_path.ps1') }
            'b' { return }
            default { Show-InvalidSelection }
        }
    }
}

function Show-InstallCustomNodeMenu {
    $customNodesDir = Join-Path $scriptRoot 'Scripts\CustomNodes'

    $scripts = @()
    if (Test-Path $customNodesDir) {
        $scripts = Get-ChildItem -Path $customNodesDir -File -Filter 'install *.ps1' |
            Sort-Object Name |
            ForEach-Object {
                [pscustomobject]@{
                    label = ($_.BaseName -replace '^install\s+', '')
                    path = $_.FullName
                }
            }
    }

    if ($scripts.Count -eq 0) {
        Write-Host "No custom node install scripts found in $customNodesDir" -ForegroundColor Yellow
        Wait-ForKey
        return
    }

    while ($true) {
        Clear-Host
        Write-Host "Install Custom Node - Select a node to install:`n"
        for ($i = 0; $i -lt $scripts.Count; $i++) {
            $idx = $i + 1
            Write-Host "$idx) $($scripts[$i].label)"
        }
        Write-Host "b) Back to main menu`n"

        [string]$subchoice = [System.Console]::ReadKey($true).KeyChar

        Write-Host "choice: $subchoice"

        if ($subchoice -match '^[0-9]$') {
            Write-Host "Selected index: $subchoice"
            $selectedIndex = ([int]$subchoice) - 1
            Write-Host "Selected index (zero-based): $selectedIndex"
            if ($selectedIndex -ge 0 -and $selectedIndex -lt $scripts.Count) {
                & $scripts[$selectedIndex].path
                Wait-ForKey
                continue
            }
        }

        switch ($subchoice) {
            'b' { return }
            default { Show-InvalidSelection }
        }
    }
}

function Deactivate-VirtualEnv {
    if (Test-Path function:deactivate -ErrorAction SilentlyContinue) {
        deactivate -nondestructive
    }
}

function Show-MainMenu() {
    while ($true) {
        Clear-Host
        Write-Host "ComfyUI Menu - Select an action:`n"
        Write-Host "1) Start ComfyUI"
        Write-Host "2) Setup ComfyUI"
        Write-Host "3) Tools"
        Write-Host "4) Download LLM"
        Write-Host "5) Install custom node"
        Write-Host "0) Exit`n"
        
        $choice = [System.Console]::ReadKey($true).KeyChar
        
        switch ($choice) {
            '1' { Start-ComfyUi }
            '2' { Show-SetupMenu }
            '3' { Show-ToolsMenu }
            '4' { Download-LLM }
            '5' { Show-InstallCustomNodeMenu }
            '0' { return }
            default { Show-InvalidSelection }
        }
    }
}

try {
    Show-MainMenu
}
catch {
}

Deactivate-VirtualEnv

Write-Host "Exiting ComfyUI Menu..."
