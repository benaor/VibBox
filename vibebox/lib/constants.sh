# =============================================================================
# VibBox - Constants
# =============================================================================
# This file is sourced, not executed directly
# =============================================================================
#
# Description:
#   Définition des variables globales et constantes utilisées dans tout le projet.
#   Contient la version, les chemins par défaut, les codes couleurs ANSI, etc.
#
# Usage:
#   source "${VIBEBOX_SOURCE_DIR}/lib/constants.sh"
#
# =============================================================================

# -----------------------------------------------------------------------------
# Version
# -----------------------------------------------------------------------------

VIBEBOX_VERSION="0.1.0"

# -----------------------------------------------------------------------------
# Chemins
# -----------------------------------------------------------------------------

VIBEBOX_DIR="$HOME/.vibebox"              # Données persistantes globales
VIBEBOX_SOURCE_DIR=""                      # Sera set dynamiquement (répertoire d'install de vibebox)
VIBE_GLOBAL_CONFIG_DIR="$HOME/.vibe"      # Config globale vibe de l'hôte

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

IMAGE_PREFIX="vibebox"
CONTAINER_PREFIX="vibebox"
WORKSPACE_MOUNT="/workspace"

# -----------------------------------------------------------------------------
# Couleurs ANSI
# -----------------------------------------------------------------------------

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_BOLD='\033[1m'
COLOR_NC='\033[0m'                         # No Color
