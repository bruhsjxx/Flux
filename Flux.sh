#!/bin/bash
set -e

echo "===== FLUX 2 AUTO SETUP BAŞLADI ====="

# wget kontrolü
if ! command -v wget &> /dev/null; then
  if command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y wget
  fi
fi

BASE_DIR="/workspace/ComfyUI/models"

mkdir -p "$BASE_DIR/diffusion_models"
mkdir -p "$BASE_DIR/clip"
mkdir -p "$BASE_DIR/vae"

# HF token kontrolü
if [ -z "$HF_TOKEN" ]; then
  echo "HATA: HF_TOKEN bulunamadı!"
  exit 1
fi

echo "FLUX2 base model indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9B/resolve/main/flux-2-klein-base-9b.safetensors?download=true" -O "$BASE_DIR/diffusion_models/flux2Klein_9b_base.safetensors"

echo "FLUX2 model indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/black-forest-labs/FLUX.2-klein-9B/resolve/main/flux-2-klein-9b.safetensors" -O "$BASE_DIR/diffusion_models/flux2Klein_9b.safetensors"

echo "Qwen encoder indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/text_encoders/qwen_3_8b.safetensors" -O "$BASE_DIR/clip/qwen_3_8b.safetensors"

echo "VAE indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors" -O "$BASE_DIR/vae/flux2-vae.safetensors"

echo "===== FLUX 2 KURULUM TAMAMLANDI ====="
