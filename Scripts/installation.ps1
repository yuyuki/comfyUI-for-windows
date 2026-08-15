# === SCRIPT D'INSTALLATION COMFYUI + WAN2.2 (Windows 11) ===

Write-Host "=== Installation ComfyUI et configuraton vidéo Wan2.2 ==="

& "$PSScriptRoot\install python.ps1"

& "$PSScriptRoot\install comfyUI.ps1"

& "$PSScriptRoot\install nvidia.ps1"

# & "$PSScriptRoot\install wan.ps1"

# & "$PSScriptRoot\install indexTTS.ps1"

& "$PSScriptRoot\install F5 TTS.ps1"

& "$PSScriptRoot\install ffmpeg.ps1"

Write-Host "=== Fin du script d'installation ==="
