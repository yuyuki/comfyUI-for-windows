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
# VÉRIFICATIONS
# ==========================
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git n'est pas installé ou absent du PATH."
    exit 1
}

if (-not (Test-Path $NodesFile)) {
    Write-Error "Fichier introuvable : $NodesFile"
    exit 1
}

if (-not (Test-Path $CustomNodesPath)) {
    New-Item -ItemType Directory -Path $CustomNodesPath | Out-Null
}

# ==========================
# LECTURE DU FICHIER
# ==========================
$Nodes = Get-Content $NodesFile |
    Where-Object { $_.Trim() -and -not $_.Trim().StartsWith("#") }

Write-Host "Custom nodes à synchroniser : $($Nodes.Count)" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

# ==========================
# SYNC
# ==========================
foreach ($repo in $Nodes) {

    $repoName = ($repo -split "/")[-1].Replace(".git", "")
    $targetPath = Join-Path $CustomNodesPath $repoName

    if (Test-Path $targetPath) {

        if (Test-Path (Join-Path $targetPath ".git")) {
            Write-Host "🔄 Mise à jour : $repoName" -ForegroundColor Yellow
            git -C $targetPath pull
        }
        else {
            Write-Host "⚠ $repoName existe mais n'est pas un dépôt Git (ignoré)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "⬇ Installation : $repoName" -ForegroundColor Green
        git clone $repo $targetPath
    }
}

Set-Location $ParentDir

Write-Host "`n✅ Synchronisation terminée. Redémarre ComfyUI." -ForegroundColor Cyan
