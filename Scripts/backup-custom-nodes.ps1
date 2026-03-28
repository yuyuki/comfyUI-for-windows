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
# VÉRIFICATIONS
# ==========================
if (-not (Test-Path $CustomNodesPath)) {
    Write-Error "Dossier custom_nodes introuvable : $CustomNodesPath"
    exit 1
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git n'est pas installé ou absent du PATH."
    exit 1
}

# ==========================
# EXPORT
# ==========================
$exported = @()

Write-Host "Analyse des custom nodes..." -ForegroundColor Cyan
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
            Write-Host "⚠ $($_.Name) (Git sans remote)" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "• $($_.Name) (manuel – ignoré)" -ForegroundColor DarkGray
        $exported += "# $($_.Name)"
    }
}

# ==========================
# ÉCRITURE DU FICHIER
# ==========================
if ($exported.Count -gt 0) {

    "# Custom nodes ComfyUI exportés le $(Get-Date -Format 'yyyy-MM-dd HH:mm')" |
        Set-Content $OutputPath

    $exported | Sort-Object -Unique | Add-Content $OutputPath

    Write-Host "`n📄 Fichier créé : $OutputPath" -ForegroundColor Cyan
}
else {
    Write-Host "`n⚠ Aucun custom node Git trouvé." -ForegroundColor Yellow
}
