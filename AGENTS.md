# AGENTS.md

Purpose
-------
This file gives concise, actionable guidance to AI coding agents working in this repository. It links to existing docs rather than duplicating them and highlights the most relevant files, run commands, and conventions an agent needs to be productive.

Quick links
-----------
- Project README: [readme.md](readme.md)
- Main application: [ComfyUI/README.md](ComfyUI/README.md)
- Contribution notes: [ComfyUI/CONTRIBUTING.md](ComfyUI/CONTRIBUTING.md)
- Test config: [ComfyUI/pytest.ini](ComfyUI/pytest.ini)

Essential knowledge for agents
-----------------------------
- Primary app entry: `ComfyUI/main.py` — run the UI from the `ComfyUI` folder.
- Node definitions and key logic: `ComfyUI/nodes.py`, `ComfyUI/node_helpers.py`.
- Custom nodes: `custom_nodes/` and the `Scripts/` helpers for managing them.
- Workflows and examples: `workflow/` and `script_examples/`.
- Outputs and models: `output/`, `models/`, and `extra_model_paths.yaml.example` — do not modify user data without asking.

Common run/test commands
------------------------
The repository is Python-based. Typical setup (PowerShell):

```powershell
python -m venv .venv
. .venv\Scripts\Activate.ps1
pip install -r ComfyUI/requirements.txt
```

Run the UI locally:

```powershell
python ComfyUI/main.py
```

Run tests:

```powershell
pytest -q
```

Project conventions and pitfalls
-------------------------------
- Prefer small, focused changes and run `pytest -q` for regressions.
- GPU/CUDA dependencies can cause environment issues; check `Scripts/` installers and `software/ffmpeg` when debugging runtime problems.
- Many helper scripts live in `Scripts/` and should be used for installing external dependencies.

Agent behavior guidelines
-------------------------
- Link to existing docs instead of copying (see Quick links).
- When proposing changes that affect model files, large data, or user outputs, ask before modifying.
- Run tests and linters when making code changes; include the commands you ran in your PR description.
- If a proposed change is broad or cross-cutting, request a short design confirmation before implementing.

Where to look next
------------------
- Code entry points: `ComfyUI/main.py`, `ComfyUI/server.py`.
- Configuration: `ComfyUI/folder_paths.py`, `extra_model_paths.yaml.example`.
- Custom node manager: `ComfyUI/custom_node_manager.py` and `custom_nodes/`.

If you'd like, I can also create specialized instruction or skill files for frontend/backend, tests, or custom-node workflows.
