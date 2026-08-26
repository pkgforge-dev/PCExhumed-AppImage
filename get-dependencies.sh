#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glu    \
    libvpx \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano gtk2-mini libdecor-mini

echo "Building PCExhumed..."
echo "---------------------------------------------------------------"
REPO="https://github.com/NBlood/NBlood"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./PCExhumed
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./PCExhumed
make pcexhumed -j$(nproc)
mv -v pcexhumed pcexhumed.pk3 ../AppDir/bin
