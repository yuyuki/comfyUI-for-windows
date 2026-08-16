$ErrorActionPreference = "Stop"

Clear-Host

Write-Host "=== ComfyUI installation and setup ==="

# 📌 1. Installation variables
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
$gitUrl = "https://github.com/comfyanonymous/ComfyUI.git"

# 📌 2. Create the AI folder if needed
Write-Host "Creating the installation folder..."
New-Item -ItemType Directory -Force -Path $ComfyUIRoot | Out-Null

# 📌 3. Install Git via winget if it is not already installed
Write-Host "Installing Git if it is not present..."
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git -e -h
} else { Write-Host "Git is already installed." }

# 📌 4. Install Git LFS
Write-Host "Installing Git LFS..."
git lfs install

# 📌 5. Clone the ComfyUI repository
Write-Host "Cloning ComfyUI..."
Set-Location $ComfyUIRoot
git clone $gitUrl .
Write-Host "ComfyUI downloaded to $ComfyUIRoot"

# 📌 6. Create and activate the Python virtual environment
Write-Host "Creating the Python virtual environment..."
python -m venv venv
$activate = "$ComfyUIRoot\venv\Scripts\Activate.ps1"
Write-Host "Activating the virtual environment..."
. $activate

# 📌 7. Update pip
python.exe -m pip install --upgrade pip

# 📌 8. Install ComfyUI dependencies...
Write-Host "Installing ComfyUI dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

Set-Location $ParentDir

Write-Host ""
Write-Host "✅ Installation completed. 🎉" -ForegroundColor Green
