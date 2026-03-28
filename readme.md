# 🎬 Recommandations pour RTX 3090 Ti – ComfyUI / Wan2.2 / IndexTTS

Ce guide compile toutes les **optimisations et réglages** pour utiliser ta RTX 3090 Ti avec ComfyUI et Wan2.2 de manière **stable et efficace**.

---

## 1️⃣ Configuration Windows

### 🔹 Désactiver Hardware Accelerated GPU Scheduling (HAGS)
- HAGS peut provoquer des **crash CUDA / OOM** sur les workloads IA lourds.
- Pour désactiver via PowerShell (Admin) :
```powershell
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f
shutdown /r /t 0
````

* Vérifier l’état après reboot :

```powershell
reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode
```

* ✅ 1 = désactivé (optimal pour IA)
* ⚠️ 2 = activé (risque instabilité)

### 🔹 Mode alimentation Windows

* Mode de puissance → **Performances élevées**
* Désactiver HAGS → voir ci-dessus
* Désactiver Hardware‑accelerated GPU scheduling

---

## 2️⃣ NVIDIA Control Panel

| Option                | Valeur recommandée             |
| --------------------- | ------------------------------ |
| Power management mode | **Prefer maximum performance** |
| CUDA GPUs             | RTX 3090 Ti                    |
| Low latency mode      | Off                            |

---

## 3️⃣ Python / ComfyUI

* **Python recommandé** : 3.12.x
* Créer l’environnement virtuel :

```powershell
py -3.12 -m venv venv
.\venv\Scripts\Activate.ps1
```

* Installer les dépendances :

```powershell
pip install --upgrade pip
pip install -r requirements.txt
```

* ⚠️ Python 3.13 non supporté

---

## 4️⃣ Variables d’environnement CUDA / PyTorch

```powershell
$env:PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True"
```

* Réduit les problèmes de fragmentation mémoire
* Indispensable pour la stabilité sur gros modèles vidéo

---

## 5️⃣ Réglages ComfyUI / Wan2.2

### 📌 Lancement

```powershell
python main.py --highvram --use-split-cross-attention
```

### 📌 Paramètres vidéo recommandés (RTX 3090 Ti)

| Paramètre  | Valeur recommandée                               |
| ---------- | ------------------------------------------------ |
| Résolution | 512×512 (stable) / 768×432 / 1280×720 (max safe) |
| FPS        | 24                                               |
| Frames     | 24–48 (selon résolution)                         |
| Steps      | 20–28                                            |
| CFG        | 6.5–8.0                                          |
| Sampler    | DPM++ 2M Karras                                  |
| Precision  | FP16                                             |
| Batch size | 1 (ou 2 à 512p)                                  |
| Seed       | Fixe par scène pour cohérence                    |

### 📌 Image → Vidéo (I2V)

* Denoise : 0.6–0.75
* Guidance : medium
* Image Strength : 0.7
* Maintenir un **seed fixe** pour cohérence entre frames

---

## 6️⃣ IndexTTS (Voix)

* Générer **audio avant vidéo**
* Export WAV 22 kHz suffisant pour dialogues
* Node ComfyUI : `IndexTTS` ou `IndexTTS2` (avancé)

---

## 7️⃣ Vérification VRAM / CUDA

* Vérifier VRAM disponible :

```powershell
nvidia-smi -l 1
```

* VRAM max : idéal < 22 Go pour éviter crash
* VRAM utilisée par ComfyUI + Wan2.2 : ~18–21 Go pour 720p

---

## 8️⃣ Conseils pratiques

* Toujours utiliser **FP16** pour Wan2.2
* Commencer avec **résolution plus basse** et augmenter progressivement
* Fixer **seed** pour chaque scène si cohérence nécessaire
* Générer **IndexTTS** avant vidéo
* Redémarrer après modification HAGS

---

## 9️⃣ Commandes utiles

* Désactiver HAGS : voir section 1
* Vérifier VRAM : `nvidia-smi -l 1`
* Lancer ComfyUI : `python main.py --highvram --use-split-cross-attention`
* Activer venv : `.\venv\Scripts\Activate.ps1`

---

## 10️⃣ Raccourci Script recommandé

Créer un **script de démarrage unique** pour :

* Activer venv
* Vérifier Python 3.12
* Vérifier HAGS
* Définir variable CUDA
* Lancer ComfyUI avec flags `--highvram --use-split-cross-attention`

```powershell
# Exemple minimal
& ".\venv\Scripts\Activate.ps1"
$env:PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True"
python main.py --highvram --use-split-cross-attention
```

---

✅ Avec ces réglages, ta **RTX 3090 Ti** est optimisée pour **stabilité maximale et performance sur ComfyUI + Wan2.2 + IndexTTS**.

```

---

Si tu veux, je peux te créer **une version “guide PDF / prêt à imprimer”**, avec **images de chemins, flags et checklists**, pour l’avoir sous la main lors de tes sessions IA 🎬.  

Veux‑tu que je fasse ça ?
```

# Tips Prompt
Prompting Tips:

 To get the perfect output from Wan2.2 model, you need perfect and detailed prompting.

1. Shot Order

-Describe the scene like a movie shot.
-Start with what the camera sees first.
-Then describe how the camera moves.
-Finish with what is revealed or shown at the end.

Example: A mountain at dawn -- camera tilts up slowly -- reveals a flock of birds flying overhead.



 2. Camera Language

 Use clear terms to tell the model how the camera should move:

-pan left/right – camera turns horizontally
-tilt up/down – camera moves up or down
-dolly in/out – camera moves forward or backward
-orbital arc – camera circles around a subject
-crane up – camera rises vertically

Wan 2.2 understands these better than the older version.



 3. Motion Modifiers

 Add words to describe how things move:

-Speed: slow-motion, fast pan, time-lapse
-Depth/motion cues: describe how things in the foreground/background move differently to show 3D depth

     e.g., "foreground leaves flutter, background hills stay still"



 4. Aesthetic Tags

 Add cinematic style:

-Lighting: harsh sunlight, soft dusk, neon glow, etc.
-Color Style: teal-orange, black-and-white, film-like tones (e.g., Kodak Portra)
-Lens or Film Style: 16mm film grain, blurry backgrounds (bokeh), CGI, etc.

These help define the look and feel of the scene.



 5. Timing & Resolution Settings

 Keep clips short: 5 seconds or less

-Use around 120 frames max

-Use 16 or 24 FPS (frames per second) – 16 is faster to test

-Use lower resolution (like 960×540) to test quickly, or higher (1280×720) for final output



 6. Negative Prompt

 This part tells the AI what you don’t want in the video. Defaults cover things like:
-bad quality, weird-looking hands/faces
-overexposure, bright colors, still images
-text, compression artifacts, clutter, too many background people

This helps avoid common AI issues.

 # list of models

 * [4x-UltraSharpV2.safetensors](https://huggingface.co/Kim2091/UltraSharpV2/resolve/main/4x-UltraSharpV2.safetensors)

# Reference

https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged
https://huggingface.co/Kijai/WanVideo_comfy/tree/main
https://github.com/kijai/ComfyUI-WanVideoWrapper

https://itch.io/blog/1009842/wan22-full-installation-guide-for-comfyui-8gb-vram-ready#:~:text=Unlock%20the%20full%20potential%20of%20AI%20video%20generation,to%20placing%20LoRA%2C%20text%20encoders%2C%20and%20VAE%20files.

https://huggingface.co/bullerwins/Wan2.2-I2V-A14B-GGUF/tree/main

https://comfyanonymous.github.io/ComfyUI_examples/wan22/

https://huggingface.co/QuantStack/Wan2.2-VACE-Fun-A14B-GGUF/tree/main/HighNoise

https://huggingface.co/Kijai/WanVideo_comfy/tree/main/Lightx2v