#!/bin/bash

# verifica argumento
if [ -z "$1" ]; then
    echo "Uso: $0 imagem.img"
    exit 1
fi

IMG="$1"
SIZE_MB=12

echo "[1] Criar imagem de ${SIZE_MB}MB..."
dd if=/dev/zero of="$IMG" bs=1M count=$SIZE_MB status=progress

echo "[2] Formatar em FAT12..."
mkfs.fat -F 12 "$IMG"

echo "[3] Instalar Syslinux..."
syslinux "$IMG"

echo "[4] Criar syslinux.cfg..."
cat << EOF > syslinux.cfg
DEFAULT kernel
LABEL kernel
    KERNEL kernel.bin
EOF

echo "[5] Copiar ficheiros para a imagem..."
mcopy -i "$IMG" syslinux.cfg ::/syslinux.cfg

# exemplo: kernel fictício
echo "BOOT OK" > kernel.bin
mcopy -i "$IMG" kernel.bin ::/kernel.bin

rm kernel.bin syslinux.cfg

echo "[OK] Imagem criada: $IMG"
