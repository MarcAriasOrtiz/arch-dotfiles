#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="mao-theme"
SOURCE="/home/mao/arch-dotfiles/sddm/themes/$THEME_NAME"
DEST="/usr/share/sddm/themes/$THEME_NAME"

echo "📁 Instalando tema '$THEME_NAME'..."

if [[ ! -d "$SOURCE" ]]; then
    echo "❌ No existe el tema:"
    echo "   $SOURCE"
    exit 1
fi

# Copiar el tema
rm -rf "$DEST"
mkdir -p /usr/share/sddm/themes
cp -a "$SOURCE" "$DEST"

# Configurar SDDM para usar el tema
mkdir -p /etc/sddm.conf.d

tee /etc/sddm.conf.d/theme.conf >/dev/null <<EOF
[Theme]
Current=$THEME_NAME
EOF

echo "✅ Tema instalado en: $DEST"
echo "✅ Configuración escrita en: /etc/sddm.conf.d/theme.conf"

echo
echo "Puedes probarlo con:"
echo "  sddm-greeter-qt6 --test-mode --theme $DEST"


# MAKE THAT SCRIPT EXECUTABLE LIKE SUDO WITH PASSWORD
# sudo EDITOR=nvim visudo -f /etc/sudoers.d/mao
# and write
# mao ALL=(root) NOPASSWD: /home/mao/arch-dotfiles/hypr/scripts/apply-theme.sh