#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_REPO="https://github.com/Ecolier/dotfiles"
INSTALL_PATH="/etc/nix-darwin"
CONFIG_DIR="$HOME/.config/nix"
CONFIG_FILE="$CONFIG_DIR/darwin-config.nix"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This installer is only for macOS systems"
fi

# Detect system architecture
if [[ "$(uname -m)" == "arm64" ]]; then
    SYSTEM="aarch64-darwin"
    log "Detected Apple Silicon Mac"
else
    SYSTEM="x86_64-darwin"
    log "Detected Intel Mac"
fi

# Get user details
read -p "Enter your username [$(whoami)]: " USERNAME
USERNAME=${USERNAME:-$(whoami)}

read -p "Enter your email: " EMAIL
if [[ -z "$EMAIL" ]]; then
    error "Email is required"
fi

read -p "Enter hostname [$(hostname)]: " HOSTNAME
HOSTNAME=${HOSTNAME:-$(hostname)}

log "Configuration:"
log "  Username: $USERNAME"
log "  Email: $EMAIL"
log "  Hostname: $HOSTNAME"
log "  System: $SYSTEM"
log "  Install path: $INSTALL_PATH"

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    log "Nix not found. Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    # Source the nix profile
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    success "Nix installed successfully"
else
    log "Nix already installed"
fi

# Check if nix-darwin is already installed
if [[ -d "$INSTALL_PATH" ]]; then
    warn "nix-darwin already installed at $INSTALL_PATH"
    read -p "Do you want to reinstall? [y/N]: " REINSTALL
    if [[ "$REINSTALL" != "y" && "$REINSTALL" != "Y" ]]; then
        log "Skipping installation"
        exit 0
    fi
    log "Removing existing installation..."
    sudo rm -rf "$INSTALL_PATH"
fi

# Clone dotfiles to /etc/nix-darwin
log "Cloning dotfiles to $INSTALL_PATH..."
sudo git clone "$DOTFILES_REPO" "$INSTALL_PATH"
sudo chown -R root:wheel "$INSTALL_PATH"

# Create user config directory
log "Creating user configuration..."
mkdir -p "$CONFIG_DIR"

# Create user-specific config file
cat > "$CONFIG_FILE" << EOF
{
  username = "$USERNAME";
  email = "$EMAIL";
  hostname = "$HOSTNAME";
  system = "$SYSTEM";
}
EOF

success "Created configuration file at $CONFIG_FILE"

# Enable flakes and nix-command
log "Enabling Nix flakes..."
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF

# Install nix-darwin
log "Installing nix-darwin..."
sudo nix run nix-darwin -- switch --flake "$INSTALL_PATH#$HOSTNAME" --impure

success "nix-darwin installation completed!"

log "Next steps:"
log "  1. Restart your terminal or run: source /etc/static/bashrc"
log "  2. To update: darwin-rebuild switch --flake $INSTALL_PATH#$HOSTNAME --impure"
log "  3. To modify config: edit $CONFIG_FILE"

success "Installation completed successfully! 🎉"