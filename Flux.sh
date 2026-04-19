#!/bin/bash
set -e

echo "===== FLUX AUTO SETUP BAŞLADI ====="

BASE_DIR="/workspace/ComfyUI/models"

mkdir -p "$BASE_DIR/checkpoints"
mkdir -p "$BASE_DIR/clip"
mkdir -p "$BASE_DIR/vae"

# 🔐 Token kontrolü (küçük harf)
if [ -z "$civitai_token" ]; then
  echo "HATA: civitai_token bulunamadı!"
  exit 1
fi

# 1️⃣ FLUX base model (Schnell)
echo "FLUX model indiriliyor..."
wget -c --content-disposition \
"https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors" \
-O "$BASE_DIR/checkpoints/flux1-schnell.safetensors"

# 2️⃣ CLIP
echo "CLIP indiriliyor..."
wget -c --content-disposition \
"https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" \
-O "$BASE_DIR/clip/clip_l.safetensors"

# 3️⃣ T5 encoder
echo "T5 indiriliyor..."
wget -c --content-disposition \
"https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors" \
-O "$BASE_DIR/clip/t5xxl_fp16.safetensors"

# 4️⃣ VAE
echo "VAE indiriliyor..."
wget -c --content-disposition \
"https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors" \
-O "$BASE_DIR/vae/ae.safetensors"

# 5️⃣ Fluxed Up (CivitAI)
echo "Fluxed Up indiriliyor..."
wget -c \
"https://civitai.com/api/download/models/2817982?token=$civitai_token" \
-O "$BASE_DIR/checkpoints/fluxed_up.safetensors"

echo "===== TÜM KURULUM TAMAMLANDI ====="
