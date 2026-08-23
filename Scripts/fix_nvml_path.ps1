<#
.SYNOPSIS
  Ensure NVML DLL is available where pynvml expects it.

.DESCRIPTION
  Copies "C:\Windows\System32\nvml.dll" to
  "C:\Program Files\NVIDIA Corporation\NVSMI\nvml.dll" so Python bindings
  (`pynvml`) can find the library. If not run as administrator the script
  will re-launch itself elevated.

.NOTES
  Run this on Windows where you have an NVIDIA driver installed. A driver
  reinstall is the more robust long-term fix, but this script is a safe
  convenience to restore the expected NVSMI layout.
#>

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-Host "Not running as admin; requesting elevation..."
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = pwsh.exe
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = "runAs"
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        exit
    } catch {
        Write-Error "Elevation cancelled or failed: $_"
        exit 1
    }
}

Write-Host "Running with admin privileges. Proceeding..."

$src = Join-Path $env:windir 'System32\nvml.dll'
$dstDir = 'C:\Program Files\NVIDIA Corporation\NVSMI'
$dst = Join-Path $dstDir 'nvml.dll'

if (-not (Test-Path $src)) {
    Write-Error "Source NVML DLL not found at $src. Ensure NVIDIA driver is installed."
    exit 2
}

try {
    if (-not (Test-Path $dstDir)) {
        Write-Host "Creating directory: $dstDir"
        New-Item -Path $dstDir -ItemType Directory -Force | Out-Null
    }

    if (Test-Path $dst) {
        $ts = (Get-Item $dst).LastWriteTime
        Write-Host "Existing NVML at $dst (modified: $ts). Backing up to ${dst}.bak"
        Copy-Item -Path $dst -Destination "${dst}.bak" -Force
    }

    Write-Host "Copying $src -> $dst"
    Copy-Item -Path $src -Destination $dst -Force
    Write-Host "Copy successful."

    Write-Host "You should restart ComfyUI to pick up GPU monitoring (restart the server)."

    Read-Host "Press Enter to exit..."

    exit 0
} catch {
    Write-Error "Operation failed: $_"

    Read-Host "Press Enter to exit..."

    exit 3
}
