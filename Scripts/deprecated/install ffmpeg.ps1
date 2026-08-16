$ErrorActionPreference = "Stop"

# 1. Path configuration
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$softwareRoot = Join-Path $ParentDir "software"
$ffmpegFolder = Join-Path $softwareRoot "ffmpeg"
$zipPath = Join-Path $softwareRoot "ffmpeg.zip"

# Use the ZIP URL for native Windows extraction
$downloadUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"

Write-Host "--- Automated FFmpeg Shared installation ---" -ForegroundColor Cyan

# 2. Create the software folder if it does not exist
if (-not (Test-Path $softwareRoot)) {
    Write-Host "Creating folder $softwareRoot" -ForegroundColor Gray
    New-Item -Path $softwareRoot -ItemType Directory | Out-Null
}

# 3. Download
Write-Host "[1/4] Downloading FFmpeg Full-Shared..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# 4. Extract
Write-Host "[2/4] Extracting files..." -ForegroundColor Yellow
if (Test-Path $ffmpegFolder) { 
    Write-Host "Removing the previous version..." -ForegroundColor Gray
    Remove-Item -Recurse -Force $ffmpegFolder 
}

Expand-Archive -Path $zipPath -DestinationPath $softwareRoot -Force

# Identify the extracted folder (name varies by version)
$extractedDir = Get-ChildItem -Path $softwareRoot -Directory | Where-Object { $_.Name -like "ffmpeg*" }

if ($extractedDir) {
    Rename-Item -Path $extractedDir.FullName -NewName "ffmpeg"
    Write-Host "Folder renamed to 'ffmpeg'." -ForegroundColor Gray
}

# 5. Configure the Windows user PATH
Write-Host "[3/4] Configuring the Windows PATH..." -ForegroundColor Yellow
$ffmpegBinPath = Join-Path $ffmpegFolder "bin"

if (Test-Path $ffmpegBinPath) {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$ffmpegBinPath*") {
        $newPath = "$currentPath;$ffmpegBinPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Host "The user PATH was updated." -ForegroundColor Green
    } else {
        Write-Host "FFmpeg is already present in PATH." -ForegroundColor Cyan
    }
}

# 6. Cleanup and validation
Remove-Item $zipPath

Write-Host "Checking FFmpeg installation..." -ForegroundColor Yellow
ffmpeg -decoders | Select-String "h264_cuvid"

set-location $ParentDir

Write-Host "[4/4] Cleanup complete. FFmpeg is ready to use." -ForegroundColor Green