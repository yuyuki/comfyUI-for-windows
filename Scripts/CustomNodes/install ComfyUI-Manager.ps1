$ErrorActionPreference = "Stop"

Write-Host "=== Installing: ComfyUI-Manager ===" -ForegroundColor Cyan

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
# 4️⃣ Create custom_nodes folder
# ------------------------
if (!(Test-Path $CustomNodesDir)) {
    New-Item -ItemType Directory -Force -Path $CustomNodesDir | Out-Null
}

# ------------------------
# 5️⃣ Install ComfyUI-Z-Engineer
# ------------------------
Write-Host "`n=== Installing ComfyUI-Manager ===" -ForegroundColor Yellow
$RepoDir = "$CustomNodesDir\ComfyUI-Manager"
$RepoUrl = "https://github.com/Comfy-Org/ComfyUI-Manager.git"

if (Test-Path $RepoDir) {
    try {
        Write-Host "Updating existing ComfyUI-Manager repo..." -ForegroundColor Yellow
        git -C "$RepoDir" pull --ff-only
    }
    catch {
        Write-Warning "Update failed. Re-cloning ComfyUI-Manager..."
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
