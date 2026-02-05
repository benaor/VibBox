#!/usr/bin/env bash
# =============================================================================
# VibBox Profile - PHP
# =============================================================================
#
# Description:
#   Profil d'installation pour le développement PHP.
#   Ce script s'exécute À L'INTÉRIEUR du conteneur Docker (en tant que user "vibe").
#
# Outils installés:
#   - PHP 8.x avec extensions courantes
#   - Composer (gestionnaire de dépendances PHP)
#   - Laravel Installer
#   - PHPUnit
#
# Usage:
#   Ce script est exécuté automatiquement lors de l'installation du profil
#   via la commande: vibebox profile php
#
# =============================================================================

set -euo pipefail

echo "📦 Installing PHP profile..."

# =============================================================================
# INSTALL PHP AND EXTENSIONS
# =============================================================================

echo "Installing PHP and extensions..."

sudo apt-get update

sudo apt-get install -y --no-install-recommends \
    php \
    php-cli \
    php-common \
    php-mbstring \
    php-xml \
    php-curl \
    php-zip \
    php-mysql \
    php-pgsql \
    php-sqlite3 \
    php-intl \
    php-gd \
    php-bcmath \
    php-tokenizer \
    || true

# Try to install php-json (may not be available as separate package in PHP 8+)
sudo apt-get install -y --no-install-recommends php-json 2>/dev/null || true

# Cleanup apt cache
sudo rm -rf /var/lib/apt/lists/*

# Verify PHP installation
echo "PHP version: $(php --version | head -1)"

# =============================================================================
# INSTALL COMPOSER
# =============================================================================

echo "Installing Composer..."

# Download and run composer installer
curl -sS https://getcomposer.org/installer | php

# Move to global location
sudo mv composer.phar /usr/local/bin/composer

# Verify composer installation
echo "Composer version: $(composer --version 2>&1 | head -1)"

# =============================================================================
# INSTALL GLOBAL PHP TOOLS VIA COMPOSER
# =============================================================================

echo "Installing global PHP tools..."

# Laravel installer
composer global require laravel/installer || true

# PHPUnit
composer global require phpunit/phpunit || true

# Add composer global bin to PATH in .zshrc if not already present
if ! grep -q '.composer/vendor/bin' ~/.zshrc 2>/dev/null; then
    echo '' >> ~/.zshrc
    echo '# Composer global bin' >> ~/.zshrc
    echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.zshrc
fi

# Also check for the newer .config/composer location
if ! grep -q '.config/composer/vendor/bin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.zshrc
fi

# =============================================================================
# FINISH
# =============================================================================

echo ""
echo "✅ PHP profile installed (PHP + Composer)"
echo "   php: $(php --version | head -1)"
echo "   composer: $(composer --version 2>&1 | head -1)"
