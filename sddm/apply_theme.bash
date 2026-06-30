#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="mao-theme"
SOURCE="$HOME/arch-dotfiles/sddm/themes/$THEME_NAME"
DEST="/usr/share/sddm/themes/$THEME_NAME"

echo "📁 Instalando tema '$THEME_NAME'..."

if [[ ! -d "$SOURCE" ]]; then
    echo "❌ No existe el tema:"
    echo "   $SOURCE"
    exit 1
fi

# Copiar el tema
sudo rm -rf "$DEST"
sudo mkdir -p /usr/share/sddm/themes
sudo cp -a "$SOURCE" "$DEST"

# Configurar SDDM para usar el tema
sudo mkdir -p /etc/sddm.conf.d

sudo tee /etc/sddm.conf.d/theme.conf >/dev/null <<EOF
[Theme]
Current=$THEME_NAME
EOF

echo "✅ Tema instalado en: $DEST"
echo "✅ Configuración escrita en: /etc/sddm.conf.d/theme.conf"

echo
echo "Puedes probarlo con:"
echo "  sddm-greeter-qt6 --test-mode --theme $DEST"