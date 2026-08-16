$ErrorActionPreference = "Stop"

Clear-Host

# ==========================
# CONFIGURATION
# ==========================

$CurrentPath = $PSScriptRoot
$rootPath = (Get-Location).Path
$ComfyUIPath = "$rootPath\ComfyUI"
$CustomNodesPath = Join-Path $ComfyUIPath "custom_nodes"
$OutputFile = "custom_nodes.txt"
$OutputPath = Join-Path $CurrentPath $OutputFile

# ==========================
# CHECKS
# ==========================
if (-not (Test-Path $CustomNodesPath)) {
    Write-Error "Custom_nodes folder not found: $CustomNodesPath"
    exit 1
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or is missing from PATH."
    exit 1
}

# ==========================
# EXPORT
# ==========================
$exported = @()

Write-Host "Analyzing custom nodes..." -ForegroundColor Cyan
Write-Host "--------------------------------"

Get-ChildItem -Path $CustomNodesPath -Directory | ForEach-Object {

    $gitDir = Join-Path $_.FullName ".git"

    if (Test-Path $gitDir) {

        $repoUrl = git -C $_.FullName remote get-url origin 2>$null

        if ($repoUrl) {
            Write-Host "✔ $($_.Name)" -ForegroundColor Green
            $exported += $repoUrl
        }
        else {
            Write-Host "⚠ $($_.Name) (Git without remote)" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "• $($_.Name) (manual – ignored)" -ForegroundColor DarkGray
        $exported += "# $($_.Name)"
    }
}

# ==========================
# WRITE FILE
# ==========================
if ($exported.Count -gt 0) {

    "# Custom nodes exported from ComfyUI on $(Get-Date -Format 'yyyy-MM-dd HH:mm')" |
        Set-Content $OutputPath

    $exported | Sort-Object -Unique | Add-Content $OutputPath

    Write-Host "`n📄 File created: $OutputPath" -ForegroundColor Cyan
}
else {
    Write-Host "`n⚠ No Git custom nodes found." -ForegroundColor Yellow
}
