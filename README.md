# Nix Darwin Dotfiles

Personal dotfiles configuration using Nix Darwin, Home Manager, and SOPS for secrets management.

## Quick Install

**Single-line installer (installs to `/etc/nix-darwin`):**

```bash
curl -sSL https://raw.githubusercontent.com/Ecolier/dotfiles/main/install-minimal.sh | bash
```

**With custom settings:**
```bash
curl -sSL https://raw.githubusercontent.com/Ecolier/dotfiles/main/install-minimal.sh | \
  USERNAME=myuser EMAIL=me@example.com HOSTNAME=MyMac bash
```

## Manual Setup

1. **Create your machine configuration:**
   ```bash
   mkdir -p ~/.config/nix
   cp darwin-config.nix.template ~/.config/nix/darwin-config.nix
   # Edit ~/.config/nix/darwin-config.nix with your details
   ```

2. **Build and switch:**
   ```bash
   darwin-rebuild switch --flake .#$(hostname) --impure
   ```

3. **For development (with direnv):**
   ```bash
   direnv allow
   ```

## Configuration Structure

- `flake.nix` - Main flake configuration
- `modules/` - System-level Darwin modules  
- `home/` - User-level Home Manager modules
- `secrets/` - SOPS encrypted secrets
- `~/.config/nix/darwin-config.nix` - Machine-specific configuration
- `install.sh` - Interactive installer
- `install-minimal.sh` - Minimal single-line installer

## Features

- 🏠 Home Manager integration
- 🔐 SOPS secrets management
- 📱 macOS system defaults
- 🍺 Homebrew integration
- 🐚 Zsh configuration
- 📝 Git and GitHub CLI setup
- 🔧 Development tools

## Commands

**After installation:**
- `darwin-rebuild switch --flake /etc/nix-darwin#$(hostname) --impure` - Apply configuration
- `nix flake update --flake /etc/nix-darwin` - Update dependencies  
- `nixfmt /etc/nix-darwin` - Format Nix files

**For development:**
- `darwin-rebuild switch --flake .#$(hostname) --impure` - Apply local changes
- `nix flake update` - Update dependencies
- `nixfmt .` - Format Nix files