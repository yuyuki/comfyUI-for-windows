# ComfyUI Setup Repository

This repository is a local Windows setup workspace for a working ComfyUI environment.

It is not a fork of ComfyUI itself. It is a practical environment for:

- installing and launching ComfyUI
- setting up Python, CUDA, and PyTorch for NVIDIA GPUs
- installing ComfyUI-Manager for easier custom node management
- installing support packages such as SageAttention
- keeping ready-to-use workflow files locally available

## Goal

Create a working setup that allows ComfyUI to run reliably on this machine, with the needed GPU stack and the tools to manage custom nodes and workflows.

## Included

- Scripts/ for install and maintenance helpers
- workflow/ for saved workflow examples
- Sources/ for local references
- Output/ for generated outputs
- software/ for bundled supporting tools

## Typical setup

```powershell
python -m venv .venv
. .\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129
pip install -r .\requirements.txt
python .\main.py
```

## Custom nodes and dependencies

ComfyUI-Manager is installed to make later custom node installation easier.

The repo also includes NVIDIA / CUDA tuning and SageAttention setup notes for stability and performance.

## Important note

A workflow dependency installer for all custom nodes used by the saved workflows is still missing and should be added later.

## Main working folders

- Scripts/
- workflow/
- Sources/
- Output/
