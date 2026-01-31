$ErrorActionPreference = "Stop"

# ================================
# Wan2.2 ComfyUI Repackaged Installer
# ================================

Write-Host "=== Installation du modèle vidéo Wan2.2 pour ComfyUI ===" -ForegroundColor Cyan

# 🔧 CONFIGURATION
$ParentDir = (Get-Location).Path
$ComfyUIRoot = "$ParentDir\ComfyUI"

# 📁 DOSSIERS CIBLES
$DiffusionDir = "$ComfyUIRoot\models\diffusion_models"
$TextEncoderDir = "$ComfyUIRoot\models\text_encoders"
$VaeDir = "$ComfyUIRoot\models\vae"

# URLs directs des fichiers à télécharger
$BaseURL = "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files"
$FilesToDownload = @(
    @{ Name = "wan2.2_ti2v_5B_fp16.safetensors"; Dest = $DiffusionDir; Subdir = "diffusion_models" },
    @{ Name = "umt5_xxl_fp8_e4m3fn_scaled.safetensors"; Dest = $TextEncoderDir; Subdir = "text_encoders" },
    @{ Name = "wan2.2_vae.safetensors"; Dest = $VaeDir; Subdir = "vae" }
)

# 📁 DOSSIERS CIBLES
$DiffusionDir = "$ComfyUIRoot\models\diffusion_models"
$TextEncoderDir = "$ComfyUIRoot\models\text_encoders"
$VaeDir = "$ComfyUIRoot\models\vae"

# 🧪 Vérifications
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ ComfyUI introuvable dans $ComfyUIRoot"
    exit 1
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Git n'est pas installé"
    exit 1
}

if (!(Get-Command git-lfs -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Git LFS n'est pas installé"
    exit 1
}

# 📁 Création des dossiers modèles
New-Item -ItemType Directory -Force -Path $DiffusionDir | Out-Null
New-Item -ItemType Directory -Force -Path $TextEncoderDir | Out-Null
New-Item -ItemType Directory -Force -Path $VaeDir | Out-Null

# ⬇️ Téléchargement sélectif des fichiers nécessaires
Write-Host "Téléchargement des fichiers Wan2.2 nécessaires..." -ForegroundColor Yellow

foreach ($file in $FilesToDownload) {
    $url = "$BaseURL/$($file.Subdir)/$($file.Name)"
    $destPath = Join-Path $file.Dest $file.Name
    Write-Host "Téléchargement de $($file.Name)..." -ForegroundColor Yellow
    $downloaded = $false
    try {
        Write-Host "Utilisation de aria2c..." -ForegroundColor Cyan
        & aria2c --continue=true --dir "$($file.Dest)" --out "$($file.Name)" "$url" 2>$null
        if ($LASTEXITCODE -eq 0) {
            $downloaded = $true
        } else {
            Write-Warning "aria2c a échoué, tentative avec Invoke-WebRequest..."
        }
        if (-not $downloaded) {
            Write-Host "Utilisation de Invoke-WebRequest..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $destPath -UseBasicParsing
            $downloaded = $true
        }
    } catch {
        Write-Error "Erreur lors du téléchargement de $($file.Name) depuis $url : $_"
        exit 1
    }
}

Set-Location $ParentDir

Write-Host "✅ Wan2.2 installé avec succès !" -ForegroundColor Green
Write-Host "Tu peux maintenant lancer ComfyUI et charger les workflows Wan2.2."
