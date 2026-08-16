# === COMFYUI + WAN2.2 INSTALLATION SCRIPT (Windows 11) ===

& "$PSScriptRoot\install python.ps1"

& "$PSScriptRoot\install comfyUI.ps1"

& "$PSScriptRoot\install nvidia.ps1"

& "$PSScriptRoot\install customnodemanager.ps1"

Write-Host "=== End of installation script ==="
