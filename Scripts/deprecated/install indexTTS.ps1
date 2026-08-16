$ErrorActionPreference = "Stop"

Clear-Host

# ==========================================
# Install IndexTTS for ComfyUI
# ==========================================

Write-Host "=== Installing IndexTTS for ComfyUI ===" -ForegroundColor Cyan

# 🔧 CONFIGURATION
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
$CustomNodesDir = "$ComfyUIRoot\custom_nodes"
$IndexTTSDir = "$CustomNodesDir\ComfyUI-Index-TTS"
$RepoURL = "https://github.com/chenpipi0807/ComfyUI-Index-TTS.git"

# 🧪 Checks
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ ComfyUI not found in $ComfyUIRoot"
    exit 1
}

if (!(Test-Path "$ComfyUIRoot\venv")) {
    Write-Error "❌ Virtual environment (venv) not found. Activate ComfyUI first."
    exit 1
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Git is not installed"
    exit 1
}

# 📁 Create custom_nodes folder
New-Item -ItemType Directory -Force -Path $CustomNodesDir | Out-Null

# 🧹 Remove old IndexTTS
if (Test-Path $IndexTTSDir) {
    Write-Host "Previous version detected, removing..." -ForegroundColor Yellow
    Remove-Item $IndexTTSDir -Recurse -Force
}

# ⬇️ Clone the IndexTTS repository
Write-Host "Downloading IndexTTS..." -ForegroundColor Yellow
git clone $RepoURL $IndexTTSDir

# 🐍 Activate the ComfyUI virtual environment
Write-Host "Activating the ComfyUI virtual environment..." -ForegroundColor Yellow
& "$ComfyUIRoot\venv\Scripts\Activate.ps1"

# 📦 Install Python dependencies
if (Test-Path "$IndexTTSDir\requirements.txt") {
    Write-Host "Installing IndexTTS Python dependencies..." -ForegroundColor Yellow
    pip install --upgrade pip
    pip install -r "$IndexTTSDir\requirements.txt"
} else {
    Write-Warning "requirements.txt not found — dependencies skipped"
}

Set-Location $ParentDir

Write-Host "✅ IndexTTS installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "👉 NEXT STEP:" -ForegroundColor Cyan
Write-Host "1) Restart ComfyUI"
Write-Host "2) Open a workflow"
Write-Host "3) Search for the 'IndexTTS' nodes"
Write-Host "4) Generate voice from text 🎤"
