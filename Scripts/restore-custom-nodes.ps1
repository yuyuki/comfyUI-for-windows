$ErrorActionPreference = "Stop"

Clear-Host

# ==========================
# CONFIGURATION
# ==========================
$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
$CustomNodesPath = Join-Path $ComfyUIRoot "custom_nodes"
$NodesFile = "custom_nodes.txt"

# ==========================
# CHECKS
# ==========================
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or missing from PATH."
    exit 1
}

if (-not (Test-Path $NodesFile)) {
    Write-Error "File not found: $NodesFile"
    exit 1
}

if (-not (Test-Path $CustomNodesPath)) {
    New-Item -ItemType Directory -Path $CustomNodesPath | Out-Null
}

# ==========================
# READ FILE
# ==========================
$Nodes = Get-Content $NodesFile |
    Where-Object { $_.Trim() -and -not $_.Trim().StartsWith("#") }

Write-Host "Custom nodes to synchronize: $($Nodes.Count)" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

# ==========================
# SYNC
# ==========================
foreach ($repo in $Nodes) {

    $repoName = ($repo -split "/")[-1].Replace(".git", "")
    $targetPath = Join-Path $CustomNodesPath $repoName

    if (Test-Path $targetPath) {

        if (Test-Path (Join-Path $targetPath ".git")) {
            Write-Host "🔄 Updating: $repoName" -ForegroundColor Yellow
            git -C $targetPath pull
        }
        else {
            Write-Host "⚠ $repoName exists but is not a Git repository (ignored)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "⬇ Installing: $repoName" -ForegroundColor Green
        git clone $repo $targetPath
    }
}

Set-Location $ParentDir

Write-Host "`n✅ Synchronization complete. Restart ComfyUI." -ForegroundColor Cyan
