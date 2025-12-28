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
    KERNEL kernel.com
EOF

echo "[5] create kernel ...."
cat << EOF > kernel.asm
loop0:
    jmp loop0
EOF

echo "[6] compile kernel ...."
nasm -f bin kernel.asm -o kernel.com

echo "[7] copy files into image..."
mcopy -i "$IMG" syslinux.cfg ::/syslinux.cfg

echo "[8] copy kernel.com
mcopy -i "$IMG" kernel.com ::/kernel.com


echo "[OK] Image copy: $IMG"
