# === SCRIPT D'INSTALLATION COMFYUI + WAN2.2 (Windows 11) ===

Write-Host "=== Installation ComfyUI et configuraton vidéo Wan2.2 ==="

& "$PSScriptRoot\Scripts\install python.ps1"

& "$PSScriptRoot\Scripts\install comfyUI.ps1"

# & "$PSScriptRoot\Scripts\install wan.ps1"

# & "$PSScriptRoot\Scripts\install indexTTS.ps1"

& "$PSScriptRoot\Scripts\install F5 TTS.ps1"

& "$PSScriptRoot\Scripts\install ffmpeg.ps1"

Write-Host "=== Fin du script d'installation ==="