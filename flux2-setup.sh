#!/bin/bash
set -e

echo "===== FLUX 2 AUTO SETUP BAŞLADI ====="

# aria2c kontrolü ve kurulumu
if ! command -v aria2c &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        echo "aria2c kuruluyor..."
        apt-get update && apt-get install -y aria2
    else
        echo "HATA: aria2c kurulamadı! (apt-get desteklenmiyor)"
        exit 1
    fi
fi

# Klasörler
BASE_DIR="/workspace/ComfyUI/models"
mkdir -p "$BASE_DIR/diffusion_models" "$BASE_DIR/clip" "$BASE_DIR/vae" "$BASE_DIR/loras"

# HF_TOKEN kontrolü
if [ -z "$HF_TOKEN" ]; then
    echo "HATA: HF_TOKEN bulunamadı! Lütfen environment variable olarak ayarlayın."
    exit 1
fi

# Aria2 ayarları
HF_ARGS="--continue=true --max-connection-per-server=16 --split=16 --min-split-size=50M --max-tries=5 --retry-wait=10 --file-allocation=prealloc --console-log-level=warn --summary-interval=30"
CV_ARGS="--continue=true --max-connection-per-server=16 --split=16 --min-split-size=20M --max-tries=5 --retry-wait=10 --file-allocation=prealloc --console-log-level=warn --summary-interval=30 --content-disposition=true"

# Yardımcı fonksiyonlar
aria2_hf() {
    aria2c $HF_ARGS --header="Authorization: Bearer $HF_TOKEN" --dir="$(dirname "$2")" --out="$(basename "$2")" "$1"
}

aria2_civitai() {
    aria2c $CV_ARGS --header="Authorization: Bearer $CIVITAI_TOKEN" --dir="$1" "$2"
}

# ====================== MODELLER ======================
echo "FLUX.2 Klein base model indiriliyor..."
aria2_hf "https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9B/resolve/main/flux-2-klein-base-9b.safetensors?download=true" "$BASE_DIR/diffusion_models/flux2Klein_9b_base.safetensors"

echo "FLUX.2 Klein model indiriliyor..."
aria2_hf "https://huggingface.co/black-forest-labs/FLUX.2-klein-9B/resolve/main/flux-2-klein-9b.safetensors" "$BASE_DIR/diffusion_models/flux2Klein_9b.safetensors"

echo "Qwen 3 8B text encoder indiriliyor..."
aria2_hf "https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/text_encoders/qwen_3_8b.safetensors" "$BASE_DIR/clip/qwen_3_8b.safetensors"

echo "VAE indiriliyor..."
aria2_hf "https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors" "$BASE_DIR/vae/flux2-vae.safetensors"

echo "===== FLUX 2 MODELLERİ KURULUM TAMAMLANDI ====="

# ====================== LORALAR ======================
if [ -z "$CIVITAI_TOKEN" ]; then
    echo "UYARI: CIVITAI_TOKEN bulunamadı, LoRA'lar indirilmeyecek."
else
    echo "LoRA'lar indiriliyor..."

    if [ -n "$LORAS" ]; then
        echo "LORAS değişkeni bulundu: $LORAS"
        
        IFS=',' read -ra LORA_ARRAY <<< "$LORAS"
        
        for ID in "${LORA_ARRAY[@]}"; do
            ID=$(echo "$ID" | xargs)
            if [ -n "$ID" ]; then
                echo "LoRA indiriliyor (ID: $ID)..."
                aria2_civitai "$BASE_DIR/loras" "https://civitai.com/api/download/models/$ID" || echo "UYARI: ID $ID indirilemedi, geçiliyor..."
            fi
        done
    else
        echo "UYARI: LORAS değişkeni boş, hiçbir LoRA indirilmeyecek."
    fi
fi

echo "===== LORA KURULUM TAMAMLANDI ====="

# Kontrol
echo "İndirilen dosyalar kontrol ediliyor..."
echo "=== Diffusion Models ==="
ls -lh "$BASE_DIR/diffusion_models/" 2>/dev/null || true
echo "=== CLIP / Text Encoders ==="
ls -lh "$BASE_DIR/clip/" 2>/dev/null || true
echo "=== VAE ==="
ls -lh "$BASE_DIR/vae/" 2>/dev/null || true
echo "=== LoRAs ==="
ls -lh "$BASE_DIR/loras/" 2>/dev/null || true

echo "===== FLUX 2 AUTO SETUP TAMAMLANDI ====="
