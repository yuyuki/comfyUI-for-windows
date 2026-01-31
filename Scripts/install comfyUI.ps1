$ErrorActionPreference = "Stop"

Write-Host "=== Installation ComfyUI et configuraton vidéo Wan2.2 ==="

# 📌 1. Variables d'installation
$ParentDir = (Get-Location).Path
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

Write-Host ""
Write-Host "=== Installation PyTorch CUDA 11.8 ===" -ForegroundColor Yellow

Write-Host "Check Cuda version on Windows"
nvidia-smi

# Désinstaller anciens torch
$pytorch = 'https://download.pytorch.org/whl/cu126'

pip uninstall -y torch torchvision torchaudio
pip install --no-cache-dir torch torchvision torchaudio --index-url $pytorch

# specific for TTS and usage of ffmpeg
pip install torchcodec --index-url=$pytorch

# improve http download performance (used with F5 TTS)
pip install hf_xet

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Erreur lors de l'installation de PyTorch"
    exit 1
}

Write-Host ""
Write-Host "=== Installation sage attention ===" -ForegroundColor Yellow
pip install sageattention

pip uninstall triton-windows
pip install -U "triton-windows<3.5"
# pip install -U "triton-windows==3.3.1.post19"

Write-Host "Nettoyage des dépendances NVIDIA..." -ForegroundColor Yellow
python -m pip uninstall pynvml -y
python -m pip install nvidia-ml-py

Set-Location $ParentDir

Write-Host ""
Write-Host "✅ Installation terminée. 🎉" -ForegroundColor Green
