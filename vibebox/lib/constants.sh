#!/usr/bin/env bash
# =============================================================================
# VibBox - Constants
# =============================================================================
#
# Description:
#   Définition des variables globales et constantes utilisées dans tout le projet.
#   Contient la version, les chemins par défaut, les codes couleurs ANSI, etc.
#
# =============================================================================

# -----------------------------------------------------------------------------
# Variables à définir:
# -----------------------------------------------------------------------------

# VERSION="0.1.0"                    # Version de VibBox

# VIBBOX_DIR                         # Répertoire d'installation de VibBox
# VIBBOX_CONFIG_DIR                  # Répertoire de configuration (~/.config/vibebox)
# VIBBOX_CACHE_DIR                   # Répertoire de cache (~/.cache/vibebox)

# IMAGE_NAME="vibebox"               # Nom de l'image Docker de base
# CONTAINER_PREFIX="vibebox-"        # Préfixe pour les noms de conteneurs

# -----------------------------------------------------------------------------
# Couleurs ANSI à définir:
# -----------------------------------------------------------------------------

# COLOR_RESET                        # Reset couleur
# COLOR_RED                          # Rouge (erreurs)
# COLOR_GREEN                        # Vert (succès)
# COLOR_YELLOW                       # Jaune (warnings)
# COLOR_BLUE                         # Bleu (info)
# COLOR_MAGENTA                      # Magenta (debug)
# COLOR_CYAN                         # Cyan (highlights)
# COLOR_BOLD                         # Texte en gras

# -----------------------------------------------------------------------------
# Chemins par défaut à définir:
# -----------------------------------------------------------------------------

# DEFAULT_WORKDIR="/workspace"       # Répertoire de travail dans le conteneur
# DEFAULT_SHELL="/bin/zsh"           # Shell par défaut dans le conteneur
# DOCKERFILE_BASE                    # Chemin vers Dockerfile.base
# PROFILES_DIR                       # Chemin vers les profils
# TEMPLATES_DIR                      # Chemin vers les templates
