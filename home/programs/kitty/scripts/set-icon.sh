#!/usr/bin/env bash
set -euo pipefail

# Check if Kitty is installed
if [ -d "/Applications/kitty.app" ]; then
  # Download a custom icon (example)
  ICON_URL="https://raw.githubusercontent.com/DinkDonk/kitty-icon/main/kitty-dark.icns"
  ICON_PATH="$HOME/.config/kitty/kitty.app.icns"
  
  # Create kitty config directory
  mkdir -p "$(dirname "$ICON_PATH")"
  
  # Download icon if it doesn't exist
  if [ ! -f "$ICON_PATH" ]; then
    echo "Downloading custom Kitty icon..."
    curl -L "$ICON_URL" -o "$ICON_PATH"
  fi
  
  # Apply the icon
  if [ -f "$ICON_PATH" ]; then
    echo "Setting custom Kitty icon..."
    rm /var/folders/*/*/*/com.apple.dock.iconcache;
    killall Dock
    echo "Custom Kitty icon applied!"
  fi
else
  echo "Kitty not found in /Applications/"
fi