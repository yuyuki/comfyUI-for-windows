# AGENTS.md

## Repository purpose

This repository is a local Windows setup workspace for a working ComfyUI environment.

The goal is not to maintain a fork of ComfyUI itself. The goal is to provide:

- a reproducible Python + CUDA + PyTorch setup
- ComfyUI installation and launch support
- NVIDIA tuning and SageAttention setup
- ComfyUI-Manager for easier custom node installation
- a library of ready-to-use workflow files

## Key folders

- [readme.md](readme.md) — project message and setup overview
- [Howto.md](Howto.md) — practical setup steps
- [Scripts/](Scripts/) — install and maintenance helpers
- [workflow/](workflow/) — saved workflows
- [Sources/](Sources/) — local source references
- [Output/](Output/) — generated outputs

## Operational rules

- Keep the setup focused on working environments, not source-code development.
- Do not modify user data, model files, or outputs without explicit permission.
- Prefer small, validated setup changes over broad repo rewrites.
- When a workflow requires custom nodes, document the missing dependency and keep the install path explicit.

## Useful starting commands

```powershell
python -m venv .venv
. .\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129
pip install -r .\requirements.txt
python .\main.py
```

## Current gap

A workflow dependency installer for all custom nodes used by the saved workflows is still missing and should be added later.
