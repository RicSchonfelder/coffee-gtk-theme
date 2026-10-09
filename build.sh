#!/usr/bin/env bash
# Coffee GTK theme — build from source
# Clones upstream Gruvbox-GTK-Theme, overlays the coffee sources, builds the
# themes, and recolours the xfwm4 assets.
set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${HERE}/.build"
UPSTREAM="https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git"

command -v git   >/dev/null || { echo "git is required"; exit 1; }
command -v sassc >/dev/null || { echo "sassc is required"; exit 1; }

echo "☕  Cloning upstream theme..."
rm -rf "$WORK"
git clone --depth 1 "$UPSTREAM" "$WORK"

echo "☕  Overlaying coffee sources..."
cp "$HERE/src/color-palette-default.scss" "$WORK/themes/src/sass/_color-palette-default.scss"
cp "$HERE/src/_colors.scss"               "$WORK/themes/src/sass/_colors.scss"
cp "$HERE/src/_colors-public.scss"        "$WORK/themes/src/sass/gtk/_colors-public.scss"
cp "$HERE/src/_common-3.0.scss"           "$WORK/themes/src/sass/gtk/_common-3.0.scss"
cp "$HERE/src/_common-4.0.scss"           "$WORK/themes/src/sass/gtk/_common-4.0.scss"

echo "☕  Building Coffee-Dark / Coffee-Light..."
( cd "$WORK/themes" && bash install.sh -n Coffee -t default -c dark -c light )

echo "☕  Recolouring xfwm4 assets (grey -> coffee)..."
bash "$HERE/tools/recolor-xfwm.sh"

echo "✅  Build done. Themes are in ~/.themes (Coffee-*)."
