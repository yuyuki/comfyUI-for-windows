$ErrorActionPreference = "Stop"

Clear-Host

# ================================
# Wan2.2 ComfyUI Repackaged Installer
# ================================

Write-Host "=== Installing the Wan2.2 video model for ComfyUI ===" -ForegroundColor Cyan

# 🔧 CONFIGURATION
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"

# 📁 TARGET FOLDERS
$DiffusionDir = "$ComfyUIRoot\models\diffusion_models"
$TextEncoderDir = "$ComfyUIRoot\models\text_encoders"
$VaeDir = "$ComfyUIRoot\models\vae"

# Direct URLs for files to download
$BaseURL = "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files"
$FilesToDownload = @(
    @{ Name = "wan2.2_ti2v_5B_fp16.safetensors"; Dest = $DiffusionDir; Subdir = "diffusion_models" },
    @{ Name = "umt5_xxl_fp8_e4m3fn_scaled.safetensors"; Dest = $TextEncoderDir; Subdir = "text_encoders" },
    @{ Name = "wan2.2_vae.safetensors"; Dest = $VaeDir; Subdir = "vae" }
)

# 📁 TARGET FOLDERS
$DiffusionDir = "$ComfyUIRoot\models\diffusion_models"
$TextEncoderDir = "$ComfyUIRoot\models\text_encoders"
$VaeDir = "$ComfyUIRoot\models\vae"

# 🧪 Checks
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ ComfyUI not found in $ComfyUIRoot"
    exit 1
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Git is not installed"
    exit 1
}

if (!(Get-Command git-lfs -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Git LFS is not installed"
    exit 1
}

# 📁 Create model folders
New-Item -ItemType Directory -Force -Path $DiffusionDir | Out-Null
New-Item -ItemType Directory -Force -Path $TextEncoderDir | Out-Null
New-Item -ItemType Directory -Force -Path $VaeDir | Out-Null

# ⬇️ Download only the required files
Write-Host "Downloading the required Wan2.2 files..." -ForegroundColor Yellow

foreach ($file in $FilesToDownload) {
    $url = "$BaseURL/$($file.Subdir)/$($file.Name)"
    $destPath = Join-Path $file.Dest $file.Name
    Write-Host "Downloading $($file.Name)..." -ForegroundColor Yellow
    $downloaded = $false
    try {
        Write-Host "Using aria2c..." -ForegroundColor Cyan
        & aria2c --continue=true --dir "$($file.Dest)" --out "$($file.Name)" "$url" 2>$null
        if ($LASTEXITCODE -eq 0) {
            $downloaded = $true
        } else {
            Write-Warning "aria2c failed, retrying with Invoke-WebRequest..."
        }
        if (-not $downloaded) {
            Write-Host "Using Invoke-WebRequest..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $destPath -UseBasicParsing
            $downloaded = $true
        }
    } catch {
        Write-Error "Error downloading $($file.Name) from $url : $_"
        exit 1
    }
}

Set-Location $ParentDir

Write-Host "✅ Wan2.2 installed successfully!" -ForegroundColor Green
Write-Host "You can now launch ComfyUI and load the Wan2.2 workflows."
