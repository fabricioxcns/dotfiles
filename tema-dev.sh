#!/usr/bin/env bash
# Tema "programador" para Linux Mint MATE: Dracula + Papirus-Dark + JetBrains Mono
set -e

# 1. Backup das configurações atuais do MATE
BACKUP=~/backup-mate-$(date +%Y%m%d-%H%M%S).dconf
dconf dump /org/mate/ > "$BACKUP"
echo "==> Backup salvo em $BACKUP"

# 2. Pacotes: ícones, fonte e ferramentas
echo "==> Instalando ícones e fonte..."
sudo apt update
sudo apt install -y git papirus-icon-theme fonts-jetbrains-mono dconf-cli

# 3. Tema Dracula (GTK + bordas Marco/Metacity)
echo "==> Baixando o tema Dracula..."
mkdir -p ~/.themes
if [ -d ~/.themes/Dracula ]; then
  git -C ~/.themes/Dracula pull
else
  git clone --depth 1 https://github.com/dracula/gtk.git ~/.themes/Dracula
fi

# 4. Aplicando tema, bordas, ícones e fonte de código
echo "==> Aplicando o visual..."
gsettings set org.mate.interface gtk-theme 'Dracula'
gsettings set org.mate.Marco.general theme 'Dracula'
gsettings set org.mate.interface icon-theme 'Papirus-Dark'
gsettings set org.mate.interface monospace-font-name 'JetBrains Mono 11'

# 5. Terminal do MATE com a paleta Dracula
echo "==> Configurando o terminal..."
PERFIL=/org/mate/terminal/profiles/default
dconf write $PERFIL/use-theme-colors false
dconf write $PERFIL/background-color "'#282A36'"
dconf write $PERFIL/foreground-color "'#F8F8F2'"
dconf write $PERFIL/bold-color-same-as-fg true
dconf write $PERFIL/palette "'#21222C:#FF5555:#50FA7B:#F1FA8C:#BD93F9:#FF79C6:#8BE9FD:#F8F8F2:#6272A4:#FF6E6E:#69FF94:#FFFFA5:#D6ACFF:#FF92DF:#A4FFFF:#FFFFFF'"
dconf write $PERFIL/use-system-font false
dconf write $PERFIL/font "'JetBrains Mono 12'"

echo ""
echo "Pronto! Feche e abra o terminal para ver as novas cores."
echo "Para desfazer tudo: dconf load /org/mate/ < $BACKUP"
