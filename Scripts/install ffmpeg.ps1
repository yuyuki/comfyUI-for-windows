$ErrorActionPreference = "Stop"

# 1. Configuration des chemins
$ParentDir = (Get-Location).Path
$softwareRoot = Join-Path $ParentDir "software"
$ffmpegFolder = Join-Path $softwareRoot "ffmpeg"
$zipPath = Join-Path $softwareRoot "ffmpeg.zip"

# Utilisation de l'URL ZIP pour extraction native Windows
$downloadUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"

Write-Host "--- Installation Automatisée de FFmpeg Shared ---" -ForegroundColor Cyan

# 2. Création du dossier software s'il n'existe pas
if (-not (Test-Path $softwareRoot)) {
    Write-Host "Création du dossier $softwareRoot" -ForegroundColor Gray
    New-Item -Path $softwareRoot -ItemType Directory | Out-Null
}

# 3. Téléchargement
Write-Host "[1/4] Téléchargement de FFmpeg Full-Shared..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# 4. Extraction
Write-Host "[2/4] Extraction des fichiers..." -ForegroundColor Yellow
if (Test-Path $ffmpegFolder) { 
    Write-Host "Suppression de l'ancienne version..." -ForegroundColor Gray
    Remove-Item -Recurse -Force $ffmpegFolder 
}

Expand-Archive -Path $zipPath -DestinationPath $softwareRoot -Force

# Identification du dossier extrait (nom variable selon la version)
$extractedDir = Get-ChildItem -Path $softwareRoot -Directory | Where-Object { $_.Name -like "ffmpeg*" }

if ($extractedDir) {
    Rename-Item -Path $extractedDir.FullName -NewName "ffmpeg"
    Write-Host "Dossier renommé en 'ffmpeg'." -ForegroundColor Gray
}

# 5. Configuration du PATH Windows (Utilisateur)
Write-Host "[3/4] Configuration du PATH Windows..." -ForegroundColor Yellow
$ffmpegBinPath = Join-Path $ffmpegFolder "bin"

if (Test-Path $ffmpegBinPath) {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$ffmpegBinPath*") {
        $newPath = "$currentPath;$ffmpegBinPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Host "Le PATH utilisateur a été mis à jour." -ForegroundColor Green
    } else {
        Write-Host "FFmpeg est déjà présent dans le PATH." -ForegroundColor Cyan
    }
}

# 6. Nettoyage et Validation
Remove-Item $zipPath

Write-Host "Vérification de l'installation de FFmpeg..." -ForegroundColor Yellow
ffmpeg -decoders | Select-String "h264_cuvid"

set-location $ParentDir

Write-Host "[4/4] Nettoyage terminé. FFmpeg est prêt à être utilisé." -ForegroundColor Green