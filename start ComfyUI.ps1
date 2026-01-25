# ======================================================
# Script de démarrage ComfyUI - Profil IA (RTX 3090 Ti)
# ======================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host

Write-Host ""
Write-Host "=== Démarrage ComfyUI (profil IA) ===" -ForegroundColor Cyan
Write-Host ""

# 🔧 CONFIGURATION (répertoire courant)
$ComfyUIRoot = "$((Get-Location).Path)\ComfyUI"
$VenvActivate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
$MainPy = "$ComfyUIRoot\main.py"

# ------------------------------------------------------
# 1️⃣ Vérification ComfyUI
# ------------------------------------------------------
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ Dossier ComfyUI introuvable : $ComfyUIRoot"
    exit 1
}

if (!(Test-Path $MainPy)) {
    Write-Error "❌ main.py introuvable dans ComfyUI"
    exit 1
}

# ------------------------------------------------------
# 2️⃣ Vérification environnement virtuel
# ------------------------------------------------------
if (!(Test-Path $VenvActivate)) {
    Write-Error "❌ Environnement virtuel introuvable (venv)"
    Write-Error "➡️ Crée-le avec : py -3.12 -m venv venv"
    exit 1
}

Write-Host "✅ Environnement ComfyUI détecté" -ForegroundColor Green

# ------------------------------------------------------
# 3️⃣ Vérification version Python
# ------------------------------------------------------
$pythonVersion = python --version

if ($pythonVersion -notmatch "3\.12") {
    Write-Warning "⚠️ Python détecté : $pythonVersion"
    Write-Warning "➡️ Python 3.12 est recommandé pour ComfyUI + Wan 2.2"
} else {
    Write-Host "✅ Python $pythonVersion" -ForegroundColor Green
}

# ------------------------------------------------------
# 4️⃣ Vérification HAGS (Hardware GPU Scheduling)
# ------------------------------------------------------
$hagsKey = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
$hags = Get-ItemProperty -Path $hagsKey -Name HwSchMode -ErrorAction SilentlyContinue

if ($null -eq $hags) {
    Write-Warning "⚠️ HAGS : état inconnu (clé absente)"
} elseif ($hags.HwSchMode -eq 1) {
    Write-Host "✅ HAGS désactivé (optimal pour IA)" -ForegroundColor Green
} elseif ($hags.HwSchMode -eq 2) {
    Write-Warning "⚠️ HAGS activé"
    Write-Warning "➡️ Peut provoquer instabilité CUDA / VRAM"
} else {
    Write-Warning "⚠️ HAGS valeur inconnue : $($hags.HwSchMode)"
}

# ------------------------------------------------------
# 5️⃣ Variables d'environnement CUDA / PyTorch
# ------------------------------------------------------
$env:PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True"

Write-Host "✅ Variables CUDA définies" -ForegroundColor Green

# ------------------------------------------------------
# 6️⃣ Activation de l'environnement virtuel
# ------------------------------------------------------
Write-Host ""
Write-Host "Activation de l'environnement virtuel..." -ForegroundColor Yellow
& $VenvActivate

# ------------------------------------------------------
# 7️⃣ Vérification PyTorch CUDA
# ------------------------------------------------------
Write-Host ""
Write-Host "Vérification de PyTorch CUDA..." -ForegroundColor Yellow

python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())" 2>$null

Write-Host $cudaCheck

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ PyTorch CUDA n'est pas disponible"
    exit 1
}

# ------------------------------------------------------
# 8️⃣ Vérification sageattention
# ------------------------------------------------------
Write-Host ""
Write-Host "Vérification de sageattention..." -ForegroundColor Yellow
python -c "import importlib.util,sys; sys.exit(0 if importlib.util.find_spec('sageattention') else 1)" 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ sageattention détecté" -ForegroundColor Green
} else {
    Write-Warning "⚠️ sageattention non installé"
    # $env:COMFY_DISABLE_SAGEATTN="1"
}

# ------------------------------------------------------
# 9️⃣ Lancement ComfyUI
# ------------------------------------------------------
Write-Host ""
Write-Host "🚀 Lancement de ComfyUI..." -ForegroundColor Cyan
Write-Host ""
Write-Host "deactivate to leave the virtual environment." -ForegroundColor Cyan

$env:PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True"

python $MainPy `
  --highvram `
  --use-split-cross-attention

# ------------------------------------------------------
# FIN
# ------------------------------------------------------