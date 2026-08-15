# ComfyUI setup notes

This repo is meant to provide a working local ComfyUI environment on Windows.

## 1. Base setup

```powershell
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
python -m venv .venv
. .\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129
pip install -r .\requirements.txt
```

## 2. Install ComfyUI-Manager

```powershell
git clone https://github.com/ltdrdata/ComfyUI-Manager .\custom_nodes\comfyui-manager
```

This is the easiest route for installing and updating custom nodes later.

## 3. NVIDIA and SageAttention

```powershell
pip uninstall triton
pip install -U "triton-windows<3.5"
pip install sageattention
```

If a module like `sageattention` is missing, install it directly in the active environment.

## 4. Launch ComfyUI

```powershell
python .\main.py
```

Or with high-VRAM settings:

```powershell
python .\main.py --highvram --use-split-cross-attention
```

## 5. Workflows

Saved workflows live in the workflow/ folder.

Load a workflow in the UI and check the required model paths for:

- checkpoints
- text encoders
- VAE files
- LoRA files
- custom nodes

## 6. Model locations

Typical folders include:

- models/unet/
- models/loras/
- models/text_encoders/
- models/vae/

## 7. Current gap

A script to automatically install all custom nodes used by the saved workflows is still missing and should be added later.