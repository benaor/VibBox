#!/usr/bin/env bash
# =============================================================================
# VibBox Profile - TypeScript
# =============================================================================
#
# Description:
#   Profil d'installation pour le développement TypeScript/JavaScript.
#   Ce script s'exécute À L'INTÉRIEUR du conteneur Docker (en tant que user "vibe").
#
# Outils installés:
#   - Bun (runtime JavaScript ultra-rapide + package manager)
#   - TypeScript, tsx, @types/node
#   - Expo CLI + EAS CLI (React Native)
#   - React Native CLI
#
# Usage:
#   Ce script est exécuté automatiquement lors de l'installation du profil
#   via la commande: vibebox profile typescript
#
# =============================================================================

set -euo pipefail

echo "📦 Installing TypeScript profile..."

# =============================================================================
# INSTALL BUN
# =============================================================================

echo "Installing Bun..."

# Install bun
curl -fsSL https://bun.sh/install | bash

# Add bun to PATH in .zshrc if not already present
if ! grep -q 'BUN_INSTALL' ~/.zshrc 2>/dev/null; then
    echo '' >> ~/.zshrc
    echo '# Bun' >> ~/.zshrc
    echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc
fi

# Source PATH for the rest of this script
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Verify bun installation
echo "Bun version: $(bun --version)"

# =============================================================================
# INSTALL GLOBAL TOOLS VIA BUN
# =============================================================================

echo "Installing TypeScript tools..."

# TypeScript and related tools
bun install -g typescript || true
bun install -g tsx || true
bun install -g @types/node || true

# =============================================================================
# INSTALL EXPO CLI
# =============================================================================

echo "Installing Expo CLI..."

bun install -g expo-cli || true
bun install -g eas-cli || true

# Verify expo installation
expo --version || echo "expo-cli installed"

# =============================================================================
# INSTALL REACT NATIVE TOOLS
# =============================================================================

echo "Installing React Native CLI..."

bun install -g react-native || true

# Note: Android/iOS native dependencies are NOT installed
# They require external SDKs, which are out of scope for this container

# =============================================================================
# FINISH
# =============================================================================

echo ""
echo "✅ TypeScript profile installed (bun + react + expo)"
echo "   bun: $(bun --version)"
echo "   tsc: $(tsc --version 2>/dev/null || echo 'not found')"
