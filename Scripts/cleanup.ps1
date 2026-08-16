$ErrorActionPreference = "Stop"

Clear-Host

$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUIRoot = "$ParentDir\ComfyUI"
if (Test-Path $ComfyUIRoot) {
    Write-Host "Removing the ComfyUI folder..."
    Remove-Item -Recurse -Force -Path $ComfyUIRoot
    Write-Host "ComfyUI folder deleted."
} else {
    Write-Host "ComfyUI folder not found. No action required."
}