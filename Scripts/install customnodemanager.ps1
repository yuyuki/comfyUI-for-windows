Write-Host "=== Installe : Custom Nodes Manager ===" -ForegroundColor Cyan

# ------------------------
# 1️⃣ Répertoire de travail
# ------------------------
$ParentDir = (Get-Location).Path
$ComfyUIRoot = "$ParentDir\ComfyUI"
$VenvActivate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
$CustomNodesDir = "$ComfyUIRoot\custom_nodes"

# ------------------------
# 2️⃣ Vérification venv
# ------------------------
if (!(Test-Path $VenvActivate)) {
    Write-Error "❌ Environnement virtuel introuvable !"
    Write-Host "➡️ Crée-le avec : py -3.12 -m venv venv"
    exit 1
}

& $VenvActivate

# ------------------------
# 4️⃣ Création dossier custom_nodes
# ------------------------
if (!(Test-Path $CustomNodesDir)) {
    New-Item -ItemType Directory -Force -Path $CustomNodesDir | Out-Null
}

# ------------------------
# 5️⃣ Installer Custom Nodes Manager
# ------------------------
Write-Host "`n=== Installation Custom Nodes Manager ===" -ForegroundColor Yellow
$CNMDir = "$CustomNodesDir\ComfyUI-CustomNodesManager"
if (Test-Path $CNMDir) { Remove-Item $CNMDir -Recurse -Force }
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git $CNMDir

# Installer requirements s’il y en a
if (Test-Path "$CNMDir\requirements.txt") {
    pip install -r "$CNMDir\requirements.txt"
}

Set-Location $ParentDir

# ------------------------
# Fin
# ------------------------
