#!/bin/bash

echo "===== CUSTOM SETUP START ====="

# === FLUX CHECKPOINT KURULUM ===

FLUX_PATH="/workspace/ComfyUI/models/checkpoints/flux_nsfw_bf16.safetensors"
FLUX_URL="https://civitai.com/api/download/models/2789377?type=Model&format=SafeTensor&size=full&fp=bf16"

if [ ! -f "$FLUX_PATH" ]; then
echo "FLUX model indiriliyor..."
mkdir -p /workspace/ComfyUI/models/checkpoints
wget -O "$FLUX_PATH" "$FLUX_URL"
else
echo "FLUX zaten mevcut, atlanıyor."
fi

echo "===== CUSTOM SETUP END ====="
