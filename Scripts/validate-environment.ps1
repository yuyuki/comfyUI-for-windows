param(
    [string]$ComfyUiRoot = (Join-Path (Resolve-Path "$PSScriptRoot\..") "ComfyUI"),
    [string]$VenvActivatePath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-PythonVersion {
    try {
        $version = & python --version 2>$null
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($version)) {
            return $null
        }

        return $version.Trim()
    }
    catch {
        return $null
    }
}

function Get-PackageVersion {
    param([string]$PackageName)

    try {
        $version = & python -c "import importlib.metadata; print(importlib.metadata.version('$PackageName'))" 2>$null
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($version)) {
            return $null
        }

        return $version.Trim()
    }
    catch {
        return $null
    }
}

function Test-IsVersionAtLeast {
    param(
        [string]$CurrentVersion,
        [string]$TargetVersion
    )

    if ([string]::IsNullOrWhiteSpace($CurrentVersion)) {
        return $false
    }

    $normalizedCurrent = ($CurrentVersion -replace '[^0-9.]', '')
    $normalizedTarget = ($TargetVersion -replace '[^0-9.]', '')

    if ([string]::IsNullOrWhiteSpace($normalizedCurrent) -or [string]::IsNullOrWhiteSpace($normalizedTarget)) {
        return $false
    }

    try {
        return ([version]$normalizedCurrent) -ge ([version]$normalizedTarget)
    }
    catch {
        return $false
    }
}

function Test-ModuleInstalled {
    param([string]$ModuleName)

    try {
        & python -c "import importlib.util; import sys; sys.exit(0 if importlib.util.find_spec('$ModuleName') else 1)" 2>$null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
}

function Write-ValidationResult {
    param(
        [string]$Label,
        [bool]$IsValid,
        [string]$Value = "",
        [string]$Warning = ""
    )

    if ($IsValid) {
        Write-Host "[OK] $Label : $Value" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] $Label : $Value" -ForegroundColor Red
        if (-not [string]::IsNullOrWhiteSpace($Warning)) {
            Write-Host "  $Warning" -ForegroundColor Yellow
        }
    }
}

function Test-Environment {
    [CmdletBinding()]
    param(
        [string]$ComfyUiRoot = $script:ComfyUiRoot,
        [string]$VenvActivatePath = $script:VenvActivatePath
    )

    $issues = @()

    Write-Host "=== Environment validation ===" -ForegroundColor Cyan

    if (-not [string]::IsNullOrWhiteSpace($VenvActivatePath)) {
        if (Test-Path $VenvActivatePath) {
            Write-Host "Activating virtual environment..." -ForegroundColor Yellow
            . $VenvActivatePath
        }
        else {
            $issues += "Virtual environment activation script not found: $VenvActivatePath"
        }
    }

    if (-not (Test-Path $ComfyUiRoot)) {
        $issues += "ComfyUI folder not found: $ComfyUiRoot"
    }
    else {
        $mainPy = Join-Path $ComfyUiRoot "main.py"
        if (-not (Test-Path $mainPy)) {
            $issues += "main.py not found in ComfyUI folder: $mainPy"
        }
    }

    $pythonVersion = Get-PythonVersion
    if ([string]::IsNullOrWhiteSpace($pythonVersion)) {
        $issues += "Python is not available or not on PATH."
    }
    else {
        Write-ValidationResult -Label "Python" -IsValid ($pythonVersion -match "3\.1[0-2]") -Value $pythonVersion -Warning "Python 3.12 is recommended for ComfyUI."
    }

    if ($PSVersionTable.PSEdition -eq "Desktop") {
        $hagsKey = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
        $hags = Get-ItemProperty -Path $hagsKey -Name HwSchMode -ErrorAction SilentlyContinue
        if ($null -eq $hags) {
            Write-Host "[WARN] HAGS state is unknown or the registry key is missing." -ForegroundColor Yellow
        }
        elseif ($hags.HwSchMode -eq 1) {
            Write-Host "[OK] HAGS is disabled." -ForegroundColor Green
        }
        elseif ($hags.HwSchMode -eq 2) {
            Write-Host "[WARN] HAGS is enabled; this may cause CUDA instability or VRAM issues." -ForegroundColor Yellow
        }
        else {
            Write-Host "[WARN] HAGS value is unknown: $($hags.HwSchMode)" -ForegroundColor Yellow
        }
    }

    try {
        $torchVersion = & python -c "import torch; print(torch.__version__)" 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "torch import failed"
        }

        $cudaAvailable = & python -c "import torch; print('true' if torch.cuda.is_available() else 'false')" 2>$null
        $cudaAvailable = $cudaAvailable.Trim()

        $torchOk = ($cudaAvailable -eq "true")
        Write-ValidationResult -Label "PyTorch" -IsValid $torchOk -Value $torchVersion -Warning "PyTorch CUDA is not available."
        if (-not $torchOk) {
            $issues += "PyTorch CUDA is not available."
        }
    }
    catch {
        $issues += "PyTorch is not available or cannot be imported."
        Write-ValidationResult -Label "PyTorch" -IsValid $false -Value "not available" -Warning "Install PyTorch with the correct CUDA build."
    }

    # Check torchvision
    try {
        $visionVersion = Get-PackageVersion -PackageName "torchvision"
        if ($visionVersion) {
            Write-ValidationResult -Label "torchvision" -IsValid $true -Value $visionVersion
        }
        else {
            $issues += "torchvision is not installed."
            Write-ValidationResult -Label "torchvision" -IsValid $false -Value "not installed" -Warning "Install torchvision compatible with your PyTorch/CUDA build."
        }
    }
    catch {
        $issues += "torchvision check failed."
        Write-ValidationResult -Label "torchvision" -IsValid $false -Value "error" -Warning "Unable to determine torchvision version."
    }

    # Check torchaudio
    try {
        $audioVersion = Get-PackageVersion -PackageName "torchaudio"
        if ($audioVersion) {
            Write-ValidationResult -Label "torchaudio" -IsValid $true -Value $audioVersion
        }
        else {
            $issues += "torchaudio is not installed."
            Write-ValidationResult -Label "torchaudio" -IsValid $false -Value "not installed" -Warning "Install torchaudio compatible with your PyTorch/CUDA build."
        }
    }
    catch {
        $issues += "torchaudio check failed."
        Write-ValidationResult -Label "torchaudio" -IsValid $false -Value "error" -Warning "Unable to determine torchaudio version."
    }

    $sageAvailable = Test-ModuleInstalled -ModuleName "sageattention"
    if ($sageAvailable) {
        $sageVersion = Get-PackageVersion -PackageName "sageattention"
        $sageDisplay = if ($sageVersion) { $sageVersion } else { "installed" }
        Write-ValidationResult -Label "sageattention" -IsValid $true -Value $sageDisplay
    }
    else {
        $issues += "sageattention is not installed."
        Write-ValidationResult -Label "sageattention" -IsValid $false -Value "not installed" -Warning "Install sageattention to match the ComfyUI CUDA stack."
    }

    $deviceCount = 0
    try {
        $deviceCount = & python -c "import torch; print(torch.cuda.device_count())" 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "cuda device count unavailable"
        }
        $deviceCount = [int]($deviceCount.Trim())
        if ($deviceCount -gt 0) {
            Write-Host "[OK] CUDA devices detected: $deviceCount" -ForegroundColor Green
        }
        else {
            $issues += "No CUDA device detected by PyTorch."
            Write-Host "[FAIL] CUDA devices detected: $deviceCount" -ForegroundColor Red
        }
    }
    catch {
        $issues += "Unable to detect CUDA devices."
        Write-Host "[FAIL] CUDA devices detected: unknown" -ForegroundColor Red
    }

    if ($issues.Count -gt 0) {
        Write-Host "" 
        Write-Host "Environment validation failed:" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "- $issue" -ForegroundColor Red
        }
        throw "Environment validation failed."
    }

    Write-Host "" 
    Write-Host "Environment validation succeeded." -ForegroundColor Green
    return $true
}

if ($MyInvocation.InvocationName -ne '.') {
    Test-Environment
}
