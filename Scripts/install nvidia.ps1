$ErrorActionPreference = "Stop"

Write-Host "=== Mise à jour ComfyUI ===" -ForegroundColor Cyan

# 📌 Variables
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"

# 📌 Activer l'environnement virtuel
$activate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
Write-Host "Activation de l'environnement virtuel..."
. $activate

# 📌 Mettre à jour PyTorch et extensions
Write-Host ""
Write-Host "=== Installation PyTorch + CUDA ===" -ForegroundColor Yellow
pip uninstall -y torch torchvision torchaudio

# $pytorchIndex = 'https://download.pytorch.org/whl/cu126'
$pytorchIndex = 'https://download.pytorch.org/whl/cu130'
pip install --no-cache-dir torch torchvision torchaudio --index-url $pytorchIndex
# pip install --no-cache-dir --upgrade "torch==2.6.0" "torchvision==0.21.0" "torchaudio==2.6.0" --index-url $pytorchIndex

# 📌 Installer le rasterizer Hunyuan3D compatible avec le support documenté par le wrapper
# $wheelPath = Join-Path $ComfyUIRoot 'custom_nodes\ComfyUI-Hunyuan3DWrapper\wheels\custom_rasterizer-0.1.0+torch260.cuda126-cp312-cp312-win_amd64.whl'
# if (Test-Path $wheelPath) {
#     Write-Host ""
#     Write-Host "=== Installation du rasterizer Hunyuan3D ===" -ForegroundColor Yellow
#     pip install --force-reinstall $wheelPath
# python -c "import custom_rasterizer, custom_rasterizer_kernel; print('rasterizer import OK')"
# } else {
#     Write-Warning "Wheel custom_rasterizer introuvable : $wheelPath"
# }

# 📌 Vérifier que l'extension charge bien
Write-Host ""
Write-Host "=== Vérification du rasterizer ===" -ForegroundColor Yellow
python -c "import torch; print('torch', torch.__version__)"

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