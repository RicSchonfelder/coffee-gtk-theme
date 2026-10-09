#!/usr/bin/env bash
# Coffee GTK theme — installer
# Copies the built themes to ~/.themes and (optionally) applies them on XFCE.
set -e

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/themes"
DEST="${HOME}/.themes"
VARIANT="${1:-Coffee-Dark}"

echo "☕  Installing Coffee GTK theme -> ${DEST}"

mkdir -p "${DEST}"
for d in "${SRC_DIR}"/Coffee-*; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    echo "   • $name"
    rm -rf "${DEST:?}/$name"
    cp -r "$d" "${DEST}/"
done

# Apply automatically on XFCE
if command -v xfconf-query >/dev/null 2>&1 && [ "${XDG_CURRENT_DESKTOP:-}" = "XFCE" ]; then
    echo "☕  Applying ${VARIANT} on XFCE..."
    xfconf-query -c xsettings -p /Net/ThemeName      -s "${VARIANT}"
    xfconf-query -c xfwm4     -p /general/theme      -s "${VARIANT}"
    # icon theme (optional, if Papirus is installed)
    if [ -d /usr/share/icons/Papirus-Dark ]; then
        xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
    fi
    echo "☕  Reloading window manager and panel..."
    (setsid xfwm4 --replace >/dev/null 2>&1 &) || true
    (setsid xfce4-panel -r  >/dev/null 2>&1 &) || true
fi

echo "✅  Done. (Choose Coffee-Dark / Coffee-Light in Settings → Appearance)"
