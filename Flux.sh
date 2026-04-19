#!/bin/bash
set -e

echo "===== FLUX 2 AUTO SETUP BAŞLADI ====="

# wget kontrolü
if ! command -v wget &> /dev/null; then
  if command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y wget
  fi
fi

BASE_DIR="/ComfyUI/models"

mkdir -p "$BASE_DIR/diffusion_models"
mkdir -p "$BASE_DIR/clip"
mkdir -p "$BASE_DIR/vae"

# HF token kontrolü
if [ -z "$HF_TOKEN" ]; then
  echo "HATA: HF_TOKEN bulunamadı!"
  exit 1
fi

echo "FLUX2 model indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9b-fp8/resolve/main/flux-2-klein-base-9b-fp8.safetensors" -O "$BASE_DIR/diffusion_models/flux2-klein-base-9b-fp8.safetensors"

echo "Qwen encoder indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/Comfy-Org/flux2-klein-9B/resolve/main/split_files/text_encoders/qwen_3_8b_fp8mixed.safetensors" -O "$BASE_DIR/clip/qwen_3_8b_fp8mixed.safetensors"

echo "VAE indiriliyor..."
wget --header="Authorization: Bearer $HF_TOKEN" -c "https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors" -O "$BASE_DIR/vae/flux2-vae.safetensors"

echo "===== FLUX 2 KURULUM TAMAMLANDI ====="
