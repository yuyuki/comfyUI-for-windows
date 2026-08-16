$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "validate-environment.ps1")

Write-Host "=== NVIDIA install (Cu130, Torch, torchvision, torchaudio) ===" -ForegroundColor Cyan

$TorchTargetVersion = "2.13.0"
$TorchVisionTargetVersion = "0.28.0"
$TorchAudioTargetVersion = "2.11.0"

$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUiRoot = Join-Path $ParentDir "ComfyUI"

$activate = Join-Path $ComfyUiRoot "venv\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) {
    throw "Virtual environment activation script not found: $activate"
}

Write-Host "Activating the virtual environment..." -ForegroundColor Yellow
. $activate

Write-Host ""
Write-Host "=== PyTorch + CUDA installation ===" -ForegroundColor Yellow

$torchCurrent = Get-PackageVersion -PackageName "torch"
$visionCurrent = Get-PackageVersion -PackageName "torchvision"
$audioCurrent = Get-PackageVersion -PackageName "torchaudio"

$shouldReinstallTorch = (-not (Test-IsVersionAtLeast -CurrentVersion $torchCurrent -TargetVersion $TorchTargetVersion)) -or
    (-not (Test-IsVersionAtLeast -CurrentVersion $visionCurrent -TargetVersion $TorchVisionTargetVersion)) -or
    (-not (Test-IsVersionAtLeast -CurrentVersion $audioCurrent -TargetVersion $TorchAudioTargetVersion))

if ($shouldReinstallTorch) {
    pip uninstall -y torch torchvision torchaudio
    $pytorchIndex = 'https://download.pytorch.org/whl/cu130'
    pip install --no-cache-dir torch torchvision torchaudio --index-url $pytorchIndex
} else {
    Write-Host "Installed torch packages are already at or above the target version. Skipping uninstall and install." -ForegroundColor Green
}

Write-Host ""
Write-Host "=== SageAttention update ===" -ForegroundColor Yellow
pip install sageattention --upgrade

Write-Host ""
Write-Host "=== NVIDIA dependency update ===" -ForegroundColor Yellow
python -m pip install --upgrade pynvml
python -m pip install --upgrade nvidia-ml-py3


Write-Host ""
Write-Host "=== Environment validation ===" -ForegroundColor Yellow
Test-Environment -ComfyUiRoot $ComfyUiRoot -VenvActivatePath $activate

Set-Location $ParentDir

Write-Host ""
Write-Host "✅ Update complete. 🎉" -ForegroundColor Green