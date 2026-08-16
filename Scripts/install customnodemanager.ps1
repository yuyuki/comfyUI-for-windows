$ErrorActionPreference = "Stop"

Write-Host "=== Installing: Custom Nodes Manager ===" -ForegroundColor Cyan

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
# 5️⃣ Install Custom Nodes Manager
# ------------------------
Write-Host "`n=== Installing Custom Nodes Manager ===" -ForegroundColor Yellow
$CNMDir = "$CustomNodesDir\ComfyUI-CustomNodesManager"

if (Test-Path $CNMDir) {
    try {
        Write-Host "Updating existing Custom Nodes Manager repo..." -ForegroundColor Yellow
        git -C "$CNMDir" pull --ff-only
    }
    catch {
        Write-Warning "Update failed. Re-cloning Custom Nodes Manager..."
        Remove-Item $CNMDir -Recurse -Force
        git clone https://github.com/Comfy-Org/ComfyUI-Manager.git $CNMDir
    }
}
else {
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git $CNMDir
}

# Install requirements if they exist
if (Test-Path "$CNMDir\requirements.txt") {
    pip install -r "$CNMDir\requirements.txt"
}

Set-Location $ParentDir

# ------------------------
# End
# ------------------------
