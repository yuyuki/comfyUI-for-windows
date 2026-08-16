$ErrorActionPreference = "Stop"

Write-Host "=== Installing: TTS-Audio-Suite ===" -ForegroundColor Cyan

# ------------------------
# 1️⃣ Working directory
# ------------------------
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
$VenvActivate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
$CustomNodesDir = "$ComfyUIRoot\custom_nodes"

# ------------------------
# 2️⃣ Virtual environment check
# ------------------------
if (!(Test-Path $VenvActivate)) {
    Write-Error "❌ Virtual environment not found!"
    Write-Host "➡️ Create it with: py -3.12 -m venv venv"
    exit 1
}

& $VenvActivate

# ------------------------
# 4️⃣ Create custom_nodes folder
# ------------------------
if (!(Test-Path $CustomNodesDir)) {
    New-Item -ItemType Directory -Force -Path $CustomNodesDir | Out-Null
}

# ------------------------
# 5️⃣ Install TTS-Audio-Suite
# ------------------------
Write-Host "`n=== Installing TTS-Audio-Suite ===" -ForegroundColor Yellow
$RepoDir = "$CustomNodesDir\TTS-Audio-Suite"
$RepoUrl = "https://github.com/diodiogod/TTS-Audio-Suite.git"

if (Test-Path $RepoDir) {
    try {
        Write-Host "Updating existing TTS-Audio-Suite repo..." -ForegroundColor Yellow
        git -C "$RepoDir" pull --ff-only
    }
    catch {
        Write-Warning "Update failed. Re-cloning TTS-Audio-Suite..."
        Remove-Item $RepoDir -Recurse -Force
        git clone $RepoUrl $RepoDir
    }
}
else {
    git clone $RepoUrl $RepoDir
}

# Install requirements if they exist
if (Test-Path "$RepoDir\requirements.txt") {
    pip install -r "$RepoDir\requirements.txt"
}

Set-Location $ParentDir

# ------------------------
# End
# ------------------------
