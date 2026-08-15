# ComfyUI-Menu.ps1
# Simple PowerShell menu to launch repository tasks

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Pause-ForKey {
    Write-Host ``
    Write-Host "Press Enter to continue..."
    Read-Host | Out-Null
}

function Get-InstallScripts {
    $scriptsDir = Join-Path $scriptRoot 'Scripts'
    if (-not (Test-Path $scriptsDir)) { return @() }
    Get-ChildItem -Path $scriptsDir -Filter 'install*.ps1' -File -ErrorAction SilentlyContinue | Sort-Object Name
}

function Run-Script {
    param([string]$relativePath)
    $full = Join-Path $scriptRoot $relativePath
    if (-not (Test-Path $full)) {
        Write-Host "Script not found: $full" -ForegroundColor Yellow
        return
    }
    Write-Host "\n=== Running: $full ===\n"
    & $full
}

while ($true) {
    Clear-Host
    Write-Host "ComfyUI Helper - Select an action:`n"
    Write-Host "1) Start ComfyUI"
    Write-Host "2) Update ComfyUI"
    Write-Host "3) Setup (install scripts)"
    Write-Host "0) Exit`n"

    $choice = Read-Host "Enter number"

    switch ($choice) {
        '1' {
            Run-Script (Join-Path 'Scripts' 'start ComfyUI.ps1')
            Pause-ForKey
        }
        '2' {
            Run-Script (Join-Path 'Scripts' 'UpdateComfyUI.ps1')
            Pause-ForKey
        }
        '3' {
            $installScripts = Get-InstallScripts
            if (-not $installScripts -or $installScripts.Count -eq 0) {
                Write-Host "No install-* scripts found in Scripts/" -ForegroundColor Yellow
                Pause-ForKey
                continue
            }

            while ($true) {
                Clear-Host
                Write-Host "Setup Menu - select an installer:`n"
                for ($i = 0; $i -lt $installScripts.Count; $i++) {
                    $num = $i + 1
                    Write-Host "${num}) $($installScripts[$i].Name)"
                }
                Write-Host "0) Back`n"

                $schoice = Read-Host "Enter number"
                if ($schoice -eq '0') { break }

                $ok = [int]::TryParse($schoice, [ref]$null)
                if ($ok -and [int]$schoice -ge 1 -and [int]$schoice -le $installScripts.Count) {
                    $idx = [int]$schoice - 1
                    $name = $installScripts[$idx].Name
                    Run-Script (Join-Path 'Scripts' $name)
                    Pause-ForKey
                } else {
                    Write-Host "Invalid selection" -ForegroundColor Red
                    Pause-ForKey
                }
            }
        }
        '0' { break }
        default {
            Write-Host "Invalid selection" -ForegroundColor Red
            Pause-ForKey
        }
    }
}

Write-Host "Exiting ComfyUI Helper."
