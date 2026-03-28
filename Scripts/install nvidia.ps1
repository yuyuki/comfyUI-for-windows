Write-Host "=== Mise à jour ComfyUI ===" -ForegroundColor Cyan

# 📌 Variables
$ParentDir = (Get-Location).Path
$ComfyUIRoot = "$ParentDir\ComfyUI"

# 📌 Activer l'environnement virtuel
$activate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
Write-Host "Activation de l'environnement virtuel..."
. $activate

# 📌 Mettre à jour PyTorch et extensions
Write-Host ""
Write-Host "=== Mise à jour PyTorch CUDA 12.6 ===" -ForegroundColor Yellow
pip uninstall -y torch torchvision torchaudio

$pytorch = 'https://download.pytorch.org/whl/cu126'
pip install --no-cache-dir torch torchvision torchaudio --index-url $pytorch

# 📌 Mettre à jour torchcodec et extensions
Write-Host ""
Write-Host "=== specific for TTS and usage of ffmpeg ===" -ForegroundColor Yellow
pip install torchcodec --index-url=$pytorch

# 📌 Mettre à jour http download performance
Write-Host ""
Write-Host "=== improve http download performance (used with F5 TTS) ===" -ForegroundColor Yellow
pip install hf_xet

# 📌 Mettre à jour de sageattention
Write-Host ""
Write-Host "=== Mise à jour de sageattention ===" -ForegroundColor Yellow
pip install sageattention --upgrade

# 📌 Mettre à jour de triton-windows
Write-Host ""
Write-Host "=== Mise à jour de triton-windows ===" -ForegroundColor Yellow
pip uninstall triton-windows
pip install -U "triton-windows==3.3.1.post19"

# 📌 Mettre à jour des dépendances NVIDIA
Write-Host "Nettoyage des dépendances NVIDIA..." -ForegroundColor Yellow
python -m pip uninstall pynvml -y
python -m pip install nvidia-ml-py

set-location $ParentDir

Write-Host ""
Write-Host "✅ Mise à jour terminée. 🎉" -ForegroundColor Green