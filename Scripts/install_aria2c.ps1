Param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

Write-Host "=== Installing aria2c (portable) ===" -ForegroundColor Cyan

$ScriptTools = Join-Path $PSScriptRoot 'tools'
$Dest = Join-Path $ScriptTools 'aria2c'
$ExePath = Join-Path $Dest 'aria2c.exe'

if (Test-Path $ExePath) {
    Write-Host "aria2c already installed at: $ExePath" -ForegroundColor Green
    Write-Host "Use -Force to reinstall." -ForegroundColor DarkYellow
    return 0
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

function Get-LatestAria2AssetUrl {
    $api = 'https://api.github.com/repos/aria2/aria2/releases/latest'
    Write-Host "Querying GitHub releases for aria2..."
    $hdr = @{ 'User-Agent' = 'aria2-installer-script' }
    $rel = Invoke-RestMethod -Uri $api -Headers $hdr
    $asset = $rel.assets | Where-Object { $_.name -match 'win' -and $_.name -match '\.zip$' } | Select-Object -First 1
    if (-not $asset) {
        throw "No Windows zip asset found in latest aria2 release"
    }
    return $asset.browser_download_url
}

try {
    $url = Get-LatestAria2AssetUrl
    Write-Host "Found asset: $url" -ForegroundColor Green
}
catch {
    Write-Warning "Failed to query GitHub releases: $_. Exception.Message"
    Write-Host "You can manually download aria2 and place aria2c.exe into $Dest" -ForegroundColor Yellow
    exit 1
}

$Tmp = Join-Path $env:TEMP ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $Tmp | Out-Null
$ZipPath = Join-Path $Tmp 'aria2.zip'

Write-Host "Downloading aria2 asset..."
Invoke-WebRequest -Uri $url -OutFile $ZipPath -UseBasicParsing

Write-Host "Extracting..."
try {
    Expand-Archive -Path $ZipPath -DestinationPath $Tmp -Force
}
catch {
    Write-Error "Failed to extract archive: $_"
    Remove-Item -Recurse -Force $Tmp
    exit 1
}

# Locate aria2c.exe in extracted tree
$found = Get-ChildItem -Path $Tmp -Recurse -Filter 'aria2c.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $found) {
    Write-Error "aria2c.exe not found inside archive"
    Remove-Item -Recurse -Force $Tmp
    exit 1
}

Copy-Item -Path $found.FullName -Destination $ExePath -Force
Write-Host "Installed aria2c to: $ExePath" -ForegroundColor Green

# Cleanup
Remove-Item -Recurse -Force $Tmp

Write-Host "Done. You can run: $ExePath" -ForegroundColor Cyan
Write-Host "The Python helper script will look for aria2c in PATH or in Scripts/tools/aria2c/aria2c.exe." -ForegroundColor Cyan

exit 0
