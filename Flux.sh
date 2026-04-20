#!/bin/bash
set -e

echo "===== FLUX 2 AUTO SETUP BAŞLADI ====="

if ! command -v aria2c &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        apt-get update && apt-get install -y aria2
    else
        echo "HATA: aria2c kurulamadı!" && exit 1
    fi
fi

BASE_DIR="/workspace/ComfyUI/models"
mkdir -p "$BASE_DIR/diffusion_models" "$BASE_DIR/clip" "$BASE_DIR/vae" "$BASE_DIR/loras"

if [ -z "$HF_TOKEN" ]; then
    echo "HATA: HF_TOKEN bulunamadı!"
    exit 1
fi

HF_ARGS="--continue=true --max-connection-per-server=16 --split=16 --min-split-size=50M --max-tries=5 --retry-wait=10 --file-allocation=prealloc --console-log-level=warn --summary-interval=30"
CV_ARGS="--continue=true --max-connection-per-server=16 --split=16 --min-split-size=20M --max-tries=5 --retry-wait=10 --file-allocation=prealloc --console-log-level=warn --summary-interval=30 --content-disposition=true"

aria2_hf() {
    aria2c $HF_ARGS --header="Authorization: Bearer $HF_TOKEN" --dir="$(dirname "$2")" --out="$(basename "$2")" "$1"
}

aria2_civitai() {
    aria2c $CV_ARGS --header="Authorization: Bearer $CIVITAI_TOKEN" --dir="$1" "$2"
}

echo "FLUX2 base model indiriliyor..."
aria2_hf "https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9B/resolve/main/flux-2-klein-base-9b.safetensors?download=true" "$BASE_DIR/diffusion_models/flux2Klein_9b_base.safetensors"

echo "FLUX2 model indiriliyor..."
aria2_hf "https://huggingface.co/black-forest-labs/FLUX.2-klein-9B/resolve/main/flux-2-klein-9b.safetensors" "$BASE_DIR/diffusion_models/flux2Klein_9b.safetensors"

echo "Qwen encoder indiriliyor..."
aria2_hf "https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/text_encoders/qwen_3_8b.safetensors" "$BASE_DIR/clip/qwen_3_8b.safetensors"

echo "VAE indiriliyor..."
aria2_hf "https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors" "$BASE_DIR/vae/flux2-vae.safetensors"

echo "===== FLUX 2 KURULUM TAMAMLANDI ====="

if [ -z "$CIVITAI_TOKEN" ]; then
    echo "UYARI: CIVITAI_TOKEN bulunamadı, LoRA indirilmeyecek"
else
    echo "LoRA'lar indiriliyor..."

    LORA_URLS=(
        "https://civitai.com/api/download/models/XXXXX"
        "https://civitai.com/api/download/models/YYYYY"
        "https://civitai.com/api/download/models/ZZZZZ"
    )

    for URL in "${LORA_URLS[@]}"; do
        echo "$URL indiriliyor..."
        aria2_civitai "$BASE_DIR/loras" "$URL" || echo "UYARI: $URL indirilemedi, geçiliyor"
    done
fi

echo "===== LORA KURULUM TAMAMLANDI ====="
