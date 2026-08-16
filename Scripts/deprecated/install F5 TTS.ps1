$ErrorActionPreference = "Stop"

# 1. Path definition
Clear-Host

$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
$VenvActivate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
$NodesPath = "$ComfyUIRoot\custom_nodes"
$F5TTSPath = "$NodesPath\comfyui-f5-tts"

Write-Host "--- Repairing F5-TTS force install ---" -ForegroundColor Cyan

# 2. Activate the virtual environment
if (Test-Path $VenvActivate) {
    Write-Host "[1/4] Activating the virtual environment..." -ForegroundColor Yellow
    & $VenvActivate
}

# 3. Clean up and reinstall cleanly via Git
if (Test-Path $F5TTSPath) {
    Write-Host "[2/4] Removing the corrupted folder..." -ForegroundColor Red
    Remove-Item -Recurse -Force $F5TTSPath
}

Write-Host "[3/4] Cloning everything in one step (with submodules)..." -ForegroundColor Yellow
Set-Location $NodesPath
# This command downloads everything at once, including missing files
git clone --recursive https://github.com/niknah/ComfyUI-F5-TTS.git

# 4. Install dependencies in the venv
Write-Host "[4/4] Installing Python dependencies..." -ForegroundColor Yellow
Set-Location $F5TTSPath
python -m pip install -r requirements.txt
python -m pip install f5-tts

Set-Location $ParentDir
Write-Host "--- Completed! Restart ComfyUI ---" -ForegroundColor Green