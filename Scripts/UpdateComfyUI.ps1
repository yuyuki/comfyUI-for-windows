$ErrorActionPreference = 'Stop'

Clear-Host

Write-Host "=== Update ComfyUI ===" -ForegroundColor Cyan

# 📌 1. Variables
$ParentDir = (Get-Location).Path
$ComfyUIRoot = "$ParentDir\ComfyUI"

# 📌 2. Verify that ComfyUI exists
if (!(Test-Path $ComfyUIRoot)) {
    Write-Error "❌ ComfyUI not found at $ComfyUIRoot"
    exit 1
}

# 📌 3. Navigate to the ComfyUI directory
Set-Location $ComfyUIRoot
Write-Host "Navigating to $ComfyUIRoot"

# 📌 5. Update the ComfyUI repository
Write-Host "Updating the ComfyUI repository..." -ForegroundColor Yellow
git checkout master
git pull

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Error during Git update"
    exit 1
}

# 📌 4. Activate the virtual environment
$activate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
Write-Host "Activating the virtual environment..."
. $activate

# 📌 6. Update pip
Write-Host ""
Write-Host "Updating pip..." -ForegroundColor Yellow
python.exe -m pip install --upgrade pip

# 📌 7. Update dependencies
Write-Host ""
Write-Host "Updating ComfyUI dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt --upgrade

& "$PSScriptRoot\install nvidia.ps1"


set-location $ParentDir

Write-Host ""
Write-Host "✅ Update completed. 🎉" -ForegroundColor Green
