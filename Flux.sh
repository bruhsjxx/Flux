#!/bin/bash

echo "FLUX SCRIPT BASLADI"
echo "===== CUSTOM SETUP START ====="

FLUX_PATH="/workspace/ComfyUI/models/checkpoints/flux_nsfw_bf16.safetensors"
FLUX_URL="https://civitai.com/api/download/models/2789377?type=Model&format=SafeTensor&size=full&fp=bf16"

if [ -z "$civitai_token" ]; then
  echo "UYARI: civitai_token bulunamadi! Indirme basarisiz olabilir."
fi

if [ ! -f "$FLUX_PATH" ]; then
  echo "FLUX model indiriliyor..."
  mkdir -p /workspace/ComfyUI/models/checkpoints

  wget --header="Authorization: Bearer $civitai_token" \
  -c --progress=bar:force \
  -O "$FLUX_PATH" "$FLUX_URL"

else
  echo "FLUX zaten mevcut, atlanıyor."
fi

echo "===== CUSTOM SETUP END ====="
