$ErrorActionPreference = "Stop"

# 1. Définition des chemins
Clear-Host

$ParentDir = (Get-Location).Path
$ComfyUIRoot = "$ParentDir\ComfyUI"
$VenvActivate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
$NodesPath = "$ComfyUIRoot\custom_nodes"
$F5TTSPath = "$NodesPath\comfyui-f5-tts"

Write-Host "--- Réparation Force de F5-TTS ---" -ForegroundColor Cyan

# 2. Activation de l'environnement virtuel
if (Test-Path $VenvActivate) {
    Write-Host "[1/4] Activation de l'environnement virtuel..." -ForegroundColor Yellow
    & $VenvActivate
}

# 3. Nettoyage et Réinstallation propre via Git
if (Test-Path $F5TTSPath) {
    Write-Host "[2/4] Suppression du dossier corrompu..." -ForegroundColor Red
    Remove-Item -Recurse -Force $F5TTSPath
}

Write-Host "[3/4] Clonage tout-en-un (avec sous-modules)..." -ForegroundColor Yellow
Set-Location $NodesPath
# Cette commande télécharge tout d'un coup, y compris les fichiers manquants
git clone --recursive https://github.com/niknah/ComfyUI-F5-TTS.git

# 4. Installation des dépendances dans le venv
Write-Host "[4/4] Installation des dépendances Python..." -ForegroundColor Yellow
Set-Location $F5TTSPath
python -m pip install -r requirements.txt
python -m pip install f5-tts

Set-Location $ParentDir
Write-Host "--- Terminé ! Relance ComfyUI ---" -ForegroundColor Green