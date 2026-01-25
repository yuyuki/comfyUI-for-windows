Write-Host "=== Download and install Python 3.12.10 (64-bit) on Windows ==="

$pythonInstallerUrl = "https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe"

$ParentDir = (Get-Location).Path

$installerPath = "$ParentDir\software\python-3.12.10-amd64.exe"

# Check if Python 3.12.10 is already installed
$pythonInstalled = $false
if (Get-Command python -ErrorAction SilentlyContinue) {
	$version = python --version
	if ($version -match "Python 3\.12\.10") {
		$pythonInstalled = $true
	}
}

if ($pythonInstalled) {
	Write-Host "Python 3.12.10 is already installed. Skipping installation."
	return
}

# Check if installer is already downloaded
if (Test-Path $installerPath) {
	Write-Host "Installer already downloaded: $installerPath"
} else {
	Write-Host "Downloading Python 3.12.10 installer..."
	if (Get-Command aria2c -ErrorAction SilentlyContinue) {
		aria2c $pythonInstallerUrl -o $installerPath
	} else {
		Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $installerPath
	}
}

Write-Host "Downloading Python 3.12.10 installer..."
if (Get-Command aria2c -ErrorAction SilentlyContinue) {
	aria2c $pythonInstallerUrl -o $installerPath
} else {
	Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $installerPath
}

Write-Host "Installing Python 3.12.10 (64-bit)..."
Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait

Set-Location $ParentDir

Write-Host "Python installation complete."
