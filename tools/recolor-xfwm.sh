#!/usr/bin/env bash
# Recolore os assets xfwm4 (Gruvbox cinza) -> paleta café
set -e

# mapa: cor_origem -> cor_cafe
MAP="
1d2021:2a1e18
121110:1a120d
3e403c:362620
333533:2a1e18
54554e:46332a
494b45:362620
4c4e48:362620
1e1c1a:150e0a
212424:221812
1f2223:1a120d
4d4e48:362620
3a3c39:2a1e18
3a3c38:2a1e18
211f1e:181009
4e4c44:2a1e18
323432:241a14
303231:221812
1c1a18:150e0a
2e302e:201610
202323:1a120d
616259:46332a
4c4d47:2a1e18
f9f5d7:f1e4cf
c0bea8:bda184
b8b7a1:b6a086
848476:8f7157
ebdbb2:e6d2b5
d5c4a1:d8bfa0
bdae93:bda184
a89984:a98a6b
928374:8f7157
7c6f64:8f7157
665c54:573f2e
504945:46332a
3c3836:362620
282828:2a1e18
ea6962:d97a5c
a9b665:a9b672
e78a4e:e0a86a
d8a657:d9b878
7daea3:7fa3ad
89b482:93b59a
d3869b:cf9a8f
d386cd:c39ac0
cc241d:b5533f
98971a:a9b672
d79921:d9b878
458588:7fa3ad
b16286:c39ac0
689d6a:93b59a
45475a:3a2a20
"

build_args() {
  local args=()
  while IFS=: read -r from to; do
    [ -z "$from" ] && continue
    args+=( -fill "#$to" -opaque "#$from" )
  done <<< "$MAP"
  printf '%s\n' "${args[@]}"
}

recolor_dir() {
  local dir="$1"
  [ -d "$dir" ] || return 0
  local count=0
  for f in "$dir"/*.png; do
    [ -e "$f" ] || continue
    # shellcheck disable=SC2046
    convert "$f" $(build_args) "$f"
    count=$((count+1))
  done
  echo "  $dir: $count arquivos recoloridos"
}

for d in "$HOME/.themes/Coffee-Dark/xfwm4" \
         "$HOME/.themes/Coffee-Dark-hdpi/xfwm4" \
         "$HOME/.themes/Coffee-Dark-xhdpi/xfwm4"; do
  recolor_dir "$d"
done

# themerc: texto/sombra café
for d in "$HOME/.themes/Coffee-Dark/xfwm4" \
         "$HOME/.themes/Coffee-Dark-hdpi/xfwm4" \
         "$HOME/.themes/Coffee-Dark-xhdpi/xfwm4"; do
  [ -f "$d/themerc" ] || continue
  sed -i 's/^active_text_color=.*/active_text_color=#f1e4cf/; s/^inactive_text_color=.*/inactive_text_color=#a98a6b/; s/^active_text_shadow_color=.*/active_text_shadow_color=#1a1310/; s/^inactive_text_shadow_color=.*/inactive_text_shadow_color=#1a1310/' "$d/themerc"
done

echo "OK"
