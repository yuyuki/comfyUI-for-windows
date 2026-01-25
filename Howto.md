# Wan 2.2 with ComfyUI

1. Install Python
git clone https://github.com/comfyanonymous/ComfyUI.git
python -m venv venv
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129
pip install -r .\requirements.txt
pip show torch
# https://github.com/woct0rdho/triton-windows
https://github.com/woct0rdho/SageAttention
pip uninstall triton
pip install -U "triton-windows<3.5"
python .\test_triton.py
git clone https://github.com/ltdrdata/ComfyUI-Manager
pip install -r .\requirements.txt
../.. python main.py


1. install `https://docs.comfy.org/installation/comfyui_portable_windows`
1. https://huggingface.co/bullerwins/Wan2.2-I2V-A14B-GGUF/tree/main
wan2.2_i2v_high_noise_14B_Q3_K_L.gguf
wan2.2_i2v_low_noise_14B_Q3_K_L.gguf

copy models in `~\ComfyUI_windows_portable\ComfyUI\models\unet\`

1. https://huggingface.co/Kijai/WanVideo_comfy/tree/main/Lightx2v

lightx2v_I2V_14B_480p_cfg_step_distill_rank32_bf16.safetensors

~\ComfyUI_windows_portable_nvidia\ComfyUI_windows_portable\ComfyUI\models\loras\

https://comfyanonymous.github.io/ComfyUI_examples/wan22/

https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/tree/main/split_files/text_encoders
umt5_xxl_fp8_e4m3fn_scaled.safetensors

~\ComfyUI_windows_portable_nvidia\ComfyUI_windows_portable\ComfyUI\models\text_encoders\

https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/blob/main/split_files/vae/wan_2.1_vae.safetensors
split_files/vae/wan_2.1_vae.safetensors
~\ComfyUI_windows_portable_nvidia\ComfyUI_windows_portable\ComfyUI\models\vae\

# Workflow
https://huggingface.co/datasets/theaidealab/workflows/tree/main
wan22_14B_i2v_gguf.json

run ComfyUI\run_nvidia_gpu.bat

Wait until you see

`To see the GUI go to: http://127.0.0.1:8188`

in e:\ComfyUI\ComfyUI_windows_portable_nvidia\ComfyUI_windows_portable\ComfyUI\custom_nodes\
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager


https://github.com/loscrossos/helper_comfyUI_accel

# Using npx (no installation required)
npx https://github.com/google-gemini/gemini-cli

launch with gemini

Prompt : `my ComfyUI is showing this message KSamplerAdvanced NO module named 'sageattention'`

Gemini executed : `pip install sageattention`


github.com/woct0rdho/SageAttention