$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUiRoot = Join-Path $ParentDir "ComfyUI"
$VenvActivate = Join-Path $ComfyUiRoot "venv\Scripts\Activate.ps1"
$MainPy = Join-Path $ComfyUiRoot "main.py"

if (-not (Test-Path $ComfyUiRoot)) {
    throw "ComfyUI folder not found: $ComfyUiRoot"
}

if (-not (Test-Path $MainPy)) {
    throw "main.py not found in ComfyUI: $MainPy"
}

if (-not (Test-Path $VenvActivate)) {
    throw "Virtual environment activation script not found: $VenvActivate"
}

Write-Host "=== Starting ComfyUI ===" -ForegroundColor Cyan
Write-Host "Validating the environment before launch..." -ForegroundColor Yellow
& (Join-Path $PSScriptRoot 'validate-environment.ps1') -ComfyUiRoot $ComfyUiRoot -VenvActivatePath $VenvActivate

. $VenvActivate
$env:PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True"

Write-Host "Launching ComfyUI..." -ForegroundColor Cyan
# python $MainPy --highvram --use-split-cross-attention --disable-smart-memory --disable-pinned-memory
# python $MainPy --disable-pinned-memory --disable-smart-memory
python $MainPy
