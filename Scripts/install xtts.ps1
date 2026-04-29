$ErrorActionPreference = "Stop"

Clear-Host

# ================================
# XTTS v2 Installer for ComfyUI
# Windows 11 + NVIDIA GPU
# ================================

Write-Host "=== XTTS v2 installation started ===" -ForegroundColor Cyan

# ---- Paths (fourni par toi)
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot   = "$ParentDir\ComfyUI"
$VenvActivate  = "$ComfyUIRoot\venv\Scripts\Activate.ps1"

# ---- Activate ComfyUI venv
Write-Host "Activating ComfyUI virtual environment..." -ForegroundColor Yellow
& $VenvActivate


# ---- Install Coqui TTS (XTTS v2 included)
Write-Host "Installing Coqui TTS (XTTS v2)..." -ForegroundColor Yellow
pip install TTS

# ---- Verify XTTS v2 model availability
Write-Host "Checking XTTS v2 model..." -ForegroundColor Yellow
tts --list_models | findstr xtts

Set-Location $ParentDir

Write-Host "=== XTTS v2 installation completed ===" -ForegroundColor Green
Write-Host "You can now generate French voice cloning with XTTS v2 🎙️" -ForegroundColor Green
