#!/bin/bash

# check 1 argument
if [ -z "$1" ]; then
    echo "Use: $0 imagem.img"
    exit 1
fi

IMG="$1"
SIZE_MB=12

echo "[1] create image de ${SIZE_MB}MB..."
dd if=/dev/zero of="$IMG" bs=1M count=$SIZE_MB status=progress

echo "[2] Format em FAT12..."
mkfs.fat -F 12 "$IMG"

echo "[3] Install Syslinux..."
syslinux "$IMG"

echo "[4] create syslinux.cfg..."
cat << EOF > syslinux.cfg
DEFAULT kernel
LABEL kernel
    KERNEL kernel.bin
EOF

echo "[5] copy files into image..."
mcopy -i "$IMG" syslinux.cfg ::/syslinux.cfg

# sample: kernel 
echo "BOOT OK" > kernel.bin
mcopy -i "$IMG" kernel.bin ::/kernel.bin

rm kernel.bin syslinux.cfg

echo "[OK] Image copy: $IMG"
