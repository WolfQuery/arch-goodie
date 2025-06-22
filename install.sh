#!/bin/bash

set -e  # Exit on error

echo "==> Beginning i3 rice installation"

# ----------------------------------------
# AUR HELPER (yay)
# ----------------------------------------
echo "==> Installing yay (AUR helper)..."
cd ~/Downloads/
if ! command -v yay &> /dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
else
  echo "yay already installed. Skipping."
fi

# ----------------------------------------
# SYSTEM DEPENDENCIES
# ----------------------------------------
echo "==> Installing system packages..."
sudo pacman -Syu --needed --noconfirm \
  rofi kitty picom i3blocks eww git unzip fastfetch nano htop \
  vscodium cava feh blueman clipman thunar dunst make base-devel

# ----------------------------------------
# KEYBOARD LAYOUT
# ----------------------------------------
echo "==> Setting system keyboard layout (Czech QWERTZ)..."
sudo localectl set-keymap cz-qwertz
sudo localectl set-x11-keymap cz qwertz

# ----------------------------------------
# CONFIG FILES
# ----------------------------------------
echo "==> Creating configuration directories..."
mkdir -p ~/.config/{i3,kitty,rofi,picom,i3blocks,eww}

echo "==> Copying config files..."
cp -rf config/i3/* ~/.config/i3/
cp -rf config/i3blocks/* ~/.config/i3blocks/
cp -rf config/kitty/* ~/.config/kitty/
cp -rf config/picom/* ~/.config/picom/
cp -rf config/rofi/* ~/.config/rofi/
cp -rf config/eww/* ~/.config/eww/

# ----------------------------------------
# XRESOURCES SETUP
# ----------------------------------------
echo "==> Setting up .Xresources autoload..."
if ! grep -Fxq "xrdb -merge ~/.Xresources" ~/.xinitrc 2>/dev/null; then
  echo "xrdb -merge ~/.Xresources" >> ~/.xinitrc
  echo "Added xrdb loading to .xinitrc"
else
  echo ".Xresources already set in .xinitrc"
fi

# ----------------------------------------
# WALLPAPERS
# ----------------------------------------
echo "==> Downloading wallpapers..."
mkdir -p ~/Pictures/
cd ~/Pictures/
if [ ! -d "wallpapers" ]; then
  git clone https://github.com/diinki/wallpapers.git
else
  echo "Wallpapers already cloned. Skipping."
fi

# ----------------------------------------
# FONTS
# ----------------------------------------
echo "==> Installing Maple Mono NL font..."
cd ~/Downloads/
mkdir -p ~/.local/share/fonts
curl -LO https://github.com/subframe7536/maple-font/releases/download/v7.3/MapleMonoNL-TTF.zip
unzip -o MapleMonoNL-TTF.zip -d MapleMonoNL-TTF
cp MapleMonoNL-TTF/*.ttf ~/.local/share/fonts/
fc-cache -fv

# ----------------------------------------
# i3lock-fancy (AUR)
# ----------------------------------------
echo "==> Installing i3lock-fancy from AUR..."
yay -S --noconfirm i3lock-fancy

echo "✅ Installation complete. You may want to reboot now!"
