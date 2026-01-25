# ==========================================
# Installation IndexTTS pour ComfyUI
# ==========================================

Write-Host "=== Installation de IndexTTS pour ComfyUI ===" -ForegroundColor Cyan

# 🔧 CONFIGURATION
$ComfyUIRoot = "$((Get-Location).Path)\ComfyUI"
$CustomNodesDir = "$ComfyUIRoot\custom_nodes"
$IndexTTSDir = "$CustomNodesDir\ComfyUI-Index-TTS"
$RepoURL = "https://github.com/chenpipi0807/ComfyUI-Index-TTS.git"

# 🧪 Vérifications
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ ComfyUI introuvable dans $ComfyUIRoot"
    exit 1
}

if (!(Test-Path "$ComfyUIRoot\venv")) {
    Write-Error "❌ Environnement virtuel (venv) introuvable. Active d'abord ComfyUI."
    exit 1
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Git n'est pas installé"
    exit 1
}

# 📁 Création dossier custom_nodes
New-Item -ItemType Directory -Force -Path $CustomNodesDir | Out-Null

# 🧹 Nettoyage ancien IndexTTS
if (Test-Path $IndexTTSDir) {
    Write-Host "Ancienne version détectée, suppression..." -ForegroundColor Yellow
    Remove-Item $IndexTTSDir -Recurse -Force
}

# ⬇️ Clonage du dépôt IndexTTS
Write-Host "Téléchargement de IndexTTS..." -ForegroundColor Yellow
git clone $RepoURL $IndexTTSDir

# 🐍 Activation venv ComfyUI
Write-Host "Activation de l'environnement virtuel ComfyUI..." -ForegroundColor Yellow
& "$ComfyUIRoot\venv\Scripts\Activate.ps1"

# 📦 Installation dépendances Python
if (Test-Path "$IndexTTSDir\requirements.txt") {
    Write-Host "Installation des dépendances Python IndexTTS..." -ForegroundColor Yellow
    pip install --upgrade pip
    pip install -r "$IndexTTSDir\requirements.txt"
} else {
    Write-Warning "requirements.txt non trouvé — dépendances ignorées"
}

Write-Host "✅ IndexTTS installé avec succès !" -ForegroundColor Green
Write-Host ""
Write-Host "👉 PROCHAINE ÉTAPE :" -ForegroundColor Cyan
Write-Host "1) Redémarre ComfyUI"
Write-Host "2) Ouvre un workflow"
Write-Host "3) Cherche les noeuds 'IndexTTS'"
Write-Host "4) Génère une voix depuis du texte 🎤"
