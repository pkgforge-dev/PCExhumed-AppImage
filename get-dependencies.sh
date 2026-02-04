#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glu      \
    libdecor \
    libvpx   \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of PCExhumed..."
echo "---------------------------------------------------------------"
REPO="https://github.com/NBlood/NBlood"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./PCExhumed
echo "$VERSION" > ~/version

cd ./PCExhumed
make pcexhumed -j$(nproc)
mv -v pcexhumed /usr/bin
mkdir -p /usr/share/games/pcexhumed
mv -v pcexhumed.pk3 /usr/share/games/pcexhumed
cp -r platform/Apple/bundles/PCExhumed.app/Contents/Resources/pcexhumed.icns /usr/share/pixmaps/pcexhumed.icns
