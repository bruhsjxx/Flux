#!/bin/bash

echo "===== FLUX AUTO SETUP BAŞLADI ====="

BASE_DIR="/workspace/ComfyUI/models"

mkdir -p $BASE_DIR/checkpoints
mkdir -p $BASE_DIR/clip
mkdir -p $BASE_DIR/vae

cd $BASE_DIR

# 1️⃣ FLUX base model (SCHNELL - hızlı ve hafif)
echo "FLUX model indiriliyor..."
wget -c https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors \
-O $BASE_DIR/checkpoints/flux1-schnell.safetensors

# 2️⃣ CLIP encoder
echo "CLIP indiriliyor..."
wget -c https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors \
-O $BASE_DIR/clip/clip_l.safetensors

# 3️⃣ T5 encoder (FLUX için kritik)
echo "T5 indiriliyor..."
wget -c https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors \
-O $BASE_DIR/clip/t5xxl_fp16.safetensors

# 4️⃣ VAE
echo "VAE indiriliyor..."
wget -c https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors \
-O $BASE_DIR/vae/ae.safetensors

echo "===== FLUX KURULUM TAMAMLANDI ====="
