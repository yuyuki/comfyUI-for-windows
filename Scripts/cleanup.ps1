$ErrorActionPreference = "Stop"

Clear-Host

$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
if (Test-Path $ComfyUIRoot) {
    Write-Host "Suppression du dossier ComfyUI..."
    Remove-Item -Recurse -Force -Path $ComfyUIRoot
    Write-Host "Dossier ComfyUI supprimé."
} else {
    Write-Host "Dossier ComfyUI introuvable. Aucune action nécessaire."
}