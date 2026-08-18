$ErrorActionPreference = 'Stop'

function Download-File {
    param (
        [string]$Url,
        [string]$OutDir
    )

    $aria2 = Join-Path $PSScriptRoot 'tools\aria2c\aria2c.exe'
    $Split = 4
    $FileName = Split-Path $Url -Leaf
    $ParentDir = Resolve-Path "$PSScriptRoot\.."
    $OutDir = Join-Path $ParentDir $OutDir

    if (-not (Test-Path $aria2)) {
        Write-Error "aria2c not found at $aria2"
        exit 1
    }

    $args = @(
        '-s', $Split.ToString(),
        '-c',
        '--file-allocation=none',
        '--max-connection-per-server=4',
        '-d', $OutDir,
        '-o', $FileName,
        '--console-log-level=warn',
        $Url
    )
    
    Write-Host "Using aria2c: $aria2"
    Write-Host "Downloading $FileName to $OutDir"

    $proc = Start-Process -FilePath $aria2 -ArgumentList $args -NoNewWindow -Wait -PassThru
    if ($proc.ExitCode -ne 0) { Write-Error "aria2c exited with code $($proc.ExitCode)"; exit $proc.ExitCode }
    Write-Host "Download finished: $(Join-Path $OutDir $FileName)" -ForegroundColor Green
}

Write-Host "=== Downloading LLM model ===" -ForegroundColor Cyan

# =================================================================== Diffusion Models
Write-Host "=== Download Diffusion Models ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\diffusion_models"

Write-Host "Downloading minimax_h3_ref2va_pruned_int8_convrot.safetensors from Hugging Face to ComfyUI\models\diffusion_models"
Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_fp8_scaled.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/JonathanColetti/Qwen3.8-27B-Uncensored-GGUF/resolve/main/Qwen3.8-27B-Uncensored-Q5_K_M.gguf" -OutDir $outDir


# =================================================================== VAE
Write-Host "=== Download VAE ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\vae"

Write-Host "Downloading minimax_h3_video_vae_fp16.safetensors from Hugging Face to ComfyUI\models\vae"
Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors" -OutDir $outDir

Write-Host "Downloading minimax_h3_audio_vae_fp32.safetensors from Hugging Face to ComfyUI\models\vae"
Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors" -OutDir $outDir

# =================================================================== Text Encoder
Write-Host "=== Download Text Encoder ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\text_encoders"

Write-Host "Downloading qwen3vl_4b_int4_convrot.safetensors from Hugging Face to ComfyUI\models\text_encoders"
Download-File -Url "https://huggingface.co/Merserk/qwen3vl-4b-int4-convrot/resolve/main/qwen3vl_4b_int4_convrot.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_fp8_scaled.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/sakamakismile/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4/resolve/main/qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors" -OutDir $outDir

# Write-Host "Downloading qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors from Hugging Face to ComfyUI\models\text_encoders"
# Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors" -OutDir $outDir

# =================================================================== Clip Projection
Write-Host "=== Download Clip projection ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\clip_projections"

# Download-File -Url "https://huggingface.co/NicoLab28/ClipProj-MiniMax-H3/resolve/main/mmh3-4b-ClipProj-celeb-mlp.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/NicoLab28/ClipProj-MiniMax-H3/resolve/main/mmh3-4b-ClipProj-v3.1-mlp.safetensors" -OutDir $outDir