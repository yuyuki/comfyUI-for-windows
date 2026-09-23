$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ParentDir = Resolve-Path "$PSScriptRoot\.."
$ComfyUiRoot = Join-Path $ParentDir "ComfyUI"
$TemplateDestination = Join-Path $ComfyUiRoot "custom_nodes"
$TemplateSource = Join-Path $PSScriptRoot "workflow\ComfyUI-CustomTemplate"
$WorkflowsDestination = Join-Path $TemplateDestination "ComfyUI-CustomTemplate\workflows"

if (-not (Test-Path $ComfyUiRoot)) {
    throw "ComfyUI folder not found: $ComfyUiRoot"
}

if (-not (Test-Path $TemplateSource)) {
    throw "Custom template node folder not found: $TemplateSource"
}

Remove-Item -LiteralPath $WorkflowsDestination -Recurse -Force -ErrorAction continue

Write-Host "Copying ComfyUI-CustomTemplate to ComfyUI custom_nodes..." -ForegroundColor Cyan
Copy-Item -Path $TemplateSource -Destination $TemplateDestination -Recurse -Force
Write-Host "Custom template node copied to: $TemplateDestination" -ForegroundColor Green
