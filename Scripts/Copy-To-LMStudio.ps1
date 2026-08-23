function Copy-ModelToLMStudio {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourceFile,
        [Parameter(Mandatory=$true)]
        [string]$FolderName
    )

    try {
        $resolvedSource = Resolve-Path -Path $SourceFile -ErrorAction Stop
        $sourceFull = $resolvedSource.Path
    } catch {
        Write-Warning "Source model not found: $SourceFile"
        return
    }

    $lmBase = Join-Path $env:USERPROFILE ".lmstudio\.internal\bundled-models"
    $targetDir = Join-Path $lmBase $FolderName
    $targetDir = Join-Path $targetDir ([System.IO.Path]::GetFileNameWithoutExtension($sourceFull))
    Write-Host "Preparing to copy model from $sourceFull to $targetDir" -ForegroundColor Cyan

    $targetFile = Join-Path $targetDir (Split-Path -Leaf $sourceFull)
    Write-Host "Target file will be: $targetFile" -ForegroundColor Cyan

    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

    if (Test-Path -Path $targetFile) {
        Write-Host "Skipping copy: $targetFile already exists." -ForegroundColor Yellow
        return
    }

    Copy-Item -Path $sourceFull -Destination $targetFile -Force
    Write-Host "Copied model to $targetFile" -ForegroundColor Green
}

Set-StrictMode -Version Latest
