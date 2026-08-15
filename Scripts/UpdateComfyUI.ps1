Clear-Host

Write-Host "=== Mise à jour ComfyUI ===" -ForegroundColor Cyan

# 📌 1. Variables
$ParentDir = (Get-Location).Path
$ComfyUIRoot = "$ParentDir\ComfyUI"

# 📌 2. Vérifier que ComfyUI existe
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ ComfyUI non trouvé à $ComfyUIRoot"
    exit 1
}

# 📌 3. Naviguer vers le répertoire ComfyUI
Set-Location $ComfyUIRoot
Write-Host "Navigation vers $ComfyUIRoot"

# 📌 5. Mettre à jour le repo ComfyUI
Write-Host "Mise à jour du repo ComfyUI..." -ForegroundColor Yellow
git checkout master
git pull

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Erreur lors de la mise à jour Git"
    exit 1
}

# 📌 4. Activer l'environnement virtuel
$activate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
Write-Host "Activation de l'environnement virtuel..."
. $activate

# 📌 6. Mettre à jour pip
Write-Host ""
Write-Host "Mise à jour de pip..." -ForegroundColor Yellow
python.exe -m pip install --upgrade pip

# 📌 7. Mettre à jour les dépendances
Write-Host ""
Write-Host "Mise à jour des dépendances ComfyUI..." -ForegroundColor Yellow
pip install -r requirements.txt --upgrade

& "$PSScriptRoot\install nvidia.ps1"


set-location $ParentDir

Write-Host ""
Write-Host "✅ Mise à jour terminée. 🎉" -ForegroundColor Green
