$ErrorActionPreference = "Stop"

Clear-Host

Write-Host "=== Installation ComfyUI et configuraton vidéo Wan2.2 ==="

# 📌 1. Variables d'installation
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
$gitUrl = "https://github.com/comfyanonymous/ComfyUI.git"

# 📌 2. Création du dossier AI si nécessaire
Write-Host "Création du dossier d'installation..."
New-Item -ItemType Directory -Force -Path $ComfyUIRoot | Out-Null

# 📌 3. Installer Git via winget si non installé
Write-Host "Installation de Git s'il n'est pas présent..."
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git -e -h
} else { Write-Host "Git déjà installé." }

# 📌 4. Installer Git LFS
Write-Host "Installation de Git LFS..."
git lfs install

# 📌 5. Cloner le repo ComfyUI
Write-Host "Clonage de ComfyUI..."
Set-Location $ComfyUIRoot
git clone $gitUrl .
Write-Host "ComfyUI téléchargé dans $ComfyUIRoot"

# 📌 6. Création et activation de l'environnement virtuel Python
Write-Host "Création de l'environnement virtuel Python..."
python -m venv venv
$activate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
Write-Host "Activation de l'environnement virtuel..."
. $activate

# 📌 7. Update pip
python.exe -m pip install --upgrade pip

# 📌 8. Installation des dépendances Python requises pour ComfyUI
Write-Host "Installation des dépendances (Torch, etc.)..." -ForegroundColor Yellow

Write-Host ""
Write-Host "Installation des dépendances ComfyUI..." -ForegroundColor Yellow
pip install -r requirements.txt

& "$PSScriptRoot\install nvidia.ps1"

Set-Location $ParentDir

Write-Host ""
Write-Host "✅ Installation terminée. 🎉" -ForegroundColor Green
