$ErrorActionPreference = 'Stop'

function Download-File {
    param (
        [string]$Url,
        [string]$OutDir,
        [string]$FileName = $(Split-Path $Url -Leaf)
    )

    $aria2 = Join-Path $PSScriptRoot 'tools\aria2c\aria2c.exe'
    $Split = 4
    # $FileName = Split-Path $Url -Leaf
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

Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_fp8_scaled.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_2512_fp8_e4m3fn.safetensors" -OutDir $outDir

# =================================================================== VAE
Write-Host "=== Download VAE ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\vae"

Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors" -OutDir $outDir

Write-Host "Downloading minimax_h3_audio_vae_fp32.safetensors from Hugging Face to ComfyUI\models\vae"
Download-File -Url "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors" -OutDir $outDir -FileName "z_image_turbo_vae.safetensors"

Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" -OutDir $outDir

# =================================================================== Text Encoder
Write-Host "=== Download Text Encoder ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\text_encoders"

Download-File -Url "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q4_K_M.gguf" -OutDir $outDir

Download-File -Url "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q6_K.gguf" -OutDir $outDir

Download-File -Url "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf" -OutDir $outDir

Download-File -Url "https://huggingface.co/petruhonk/Qwen3.8-9B-Distill-uncensored-heretic-GGUF/resolve/main/Qwen3.8-9B-Distill-Heretic-Uncensored-Q8_0.gguf" -OutDir $outDir

Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/llmfan46/Mistral-Small-3.2-24B-Instruct-2506-ultra-uncensored-heretic-GGUF/resolve/main/Mistral-Small-3.2-24B-Instruct-2506-ultra-uncensored-heretic-Q5_K_M.gguf" -OutDir $outDir

# =================================================================== Clip
Write-Host "=== Download Clip ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\clip"

Download-File -Url "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors" -OutDir $outDir
Download-File -Url "https://huggingface.co/BennyDaBall/Z-Image-Engineer-V6-GGUF/resolve/main/Z-Image-Engineer-V6-Q8_0.gguf" -OutDir $outDir

# =================================================================== Clip Projection
Write-Host "=== Download Clip projection ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\clip_projections"

Download-File -Url "https://huggingface.co/NicoLab28/ClipProj-MiniMax-H3/resolve/main/mmh3-4b-ClipProj-v3.1-mlp.safetensors" -OutDir $outDir


# =================================================================== LoRAs
Write-Host "=== Download LoRAs ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\loras"

Download-File -Url "https://huggingface.co/Heartsync/Flux-NSFW-uncensored/resolve/main/lora.safetensors" -OutDir $outDir
Download-File -Url "https://huggingface.co/thutes-gbr25/NSFW-MASTER-Z-IMAGE-TURBO/resolve/main/NSFW_master_ZIT_000008766.safetensors" -OutDir $outDir
Download-File -Url "https://huggingface.co/lightx2v/Qwen-Image-2512-Lightning/resolve/main/Qwen-Image-2512-Lightning-4steps-V1.0-fp32.safetensors" -OutDir $outDir
Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/loras/Qwen-Image-Edit-2509-Light-Migration.safetensors" -OutDir $outDir

# =================================================================== UNET (GGUF)
Write-Host "=== Download GGUF ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\unet"

Download-File -Url "https://huggingface.co/city96/FLUX.2-dev-gguf/resolve/main/flux2-dev-Q4_K_M.gguf" -OutDir $outDir
Download-File -Url "https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q8_0.gguf" -OutDir $outDir
Download-File -Url "https://huggingface.co/unsloth/Qwen-Image-2512-GGUF/resolve/main/qwen-image-2512-Q5_K_M.gguf" -OutDir $outDir

# =================================================================== model_patches
Write-Host "=== Download model_patches ===" -ForegroundColor Cyan
$outDir = "ComfyUI\models\model_patches"

Download-File -Url "https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union.safetensors" -OutDir $outDir

Download-File -Url "https://huggingface.co/SandLogicTechnologies/translategemma-4b-it-GGUF/resolve/main/translategemma-4b_Q5_K_M.gguf" -OutDir $outDir

# =================================================================== Copy LLM to LMStudio bundled-models
# Uses the reusable function in Scripts/Copy-To-LMStudio.ps1 to copy downloaded models
Write-Host "=== Copy Models to LMStudio ===" -ForegroundColor Cyan

$copyScript = Join-Path $PSScriptRoot 'Copy-To-LMStudio.ps1'
. $copyScript

$sourceParent = Resolve-Path "$PSScriptRoot\.."

$sourceFile = Join-Path $sourceParent "ComfyUI\models\clip\Z-Image-Engineer-V6-Q8_0.gguf"
Copy-ModelToLMStudio -SourceFile $sourceFile -FolderName "Z-Image"

$sourceFile = Join-Path $sourceParent "ComfyUI\models\text_encoders\Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q6_K.gguf"
Copy-ModelToLMStudio -SourceFile $sourceFile -FolderName "Qwen"

$sourceFile = Join-Path $sourceParent "ComfyUI\models\text_encoders\Mistral-Small-3.2-24B-Instruct-2506-ultra-uncensored-heretic-Q5_K_M.gguf"
Copy-ModelToLMStudio -SourceFile $sourceFile -FolderName "Qwen"

$sourceFile = Join-Path $sourceParent "ComfyUI\models\text_encoders\Qwen3.8-9B-Distill-Heretic-Uncensored-Q8_0.gguf"
Copy-ModelToLMStudio -SourceFile $sourceFile -FolderName "Qwen"

Write-Host "=== Finished downloading and copying models ===" -ForegroundColor Green