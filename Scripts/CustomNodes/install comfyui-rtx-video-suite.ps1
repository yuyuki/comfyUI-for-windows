$ErrorActionPreference = "Stop"

Write-Host "=== Installing: ComfyUI-RTX-Video-Suite ===" -ForegroundColor Cyan

# ------------------------
# 1️⃣ Working directory
# ------------------------
$ParentDir = Resolve-Path "$PSScriptRoot\..\.."
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
# 3️⃣ Create custom_nodes folder
# ------------------------
if (!(Test-Path $CustomNodesDir)) {
    New-Item -ItemType Directory -Force -Path $CustomNodesDir | Out-Null
}

# ------------------------
# 4️⃣ Install ComfyUI-RTX-Video-Suite
# ------------------------
Write-Host "`n=== Installing ComfyUI-RTX-Video-Suite ===" -ForegroundColor Yellow
$RepoDir = "$CustomNodesDir\ComfyUI-RTX-Video-Suite"
$RepoUrl = "https://github.com/uczensokratesa/ComfyUI-RTX-Video-Suite.git"

if (Test-Path $RepoDir) {
    try {
        Write-Host "Updating existing ComfyUI-RTX-Video-Suite repo..." -ForegroundColor Yellow
        git -C "$RepoDir" pull --ff-only
    }
    catch {
        Write-Warning "Update failed. Re-cloning ComfyUI-RTX-Video-Suite..."
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
