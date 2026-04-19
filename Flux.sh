#!/bin/bash
set -e

echo "===== FLUX AUTO SETUP BAŞLADI ====="

# wget kontrolü
if ! command -v wget &> /dev/null; then
  if command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y wget
  fi
fi

BASE_DIR="/workspace/ComfyUI/models"

mkdir -p "$BASE_DIR/checkpoints"
mkdir -p "$BASE_DIR/clip"
mkdir -p "$BASE_DIR/vae"

# Token kontrolleri
if [ -z "$civitai_token" ]; then
  echo "HATA: civitai_token bulunamadı!"
  exit 1
fi

if [ -z "$HF_TOKEN" ]; then
  echo "UYARI: HF_TOKEN yok, HuggingFace indirmeleri fail olabilir"
fi

# HuggingFace header
HF_HEADER=""
if [ ! -z "$HF_TOKEN" ]; then
  HF_HEADER="--header=Authorization: Bearer $HF_TOKEN"
fi

echo "FLUX model indiriliyor..."
wget $HF_HEADER -c --content-disposition "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors" -O "$BASE_DIR/checkpoints/flux1-schnell.safetensors"

echo "CLIP indiriliyor..."
wget $HF_HEADER -c --content-disposition "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" -O "$BASE_DIR/clip/clip_l.safetensors"

echo "T5 indiriliyor..."
wget $HF_HEADER -c --content-disposition "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors" -O "$BASE_DIR/clip/t5xxl_fp16.safetensors"

echo "VAE indiriliyor..."
wget $HF_HEADER -c --content-disposition "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors" -O "$BASE_DIR/vae/ae.safetensors"

echo "Fluxed Up indiriliyor..."
wget -c "https://civitai.com/api/download/models/2817982?token=$civitai_token" -O "$BASE_DIR/checkpoints/fluxed_up.safetensors"

echo "===== TÜM KURULUM TAMAMLANDI ====="
