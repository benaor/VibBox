# =============================================================================
# VibBox - Utility Functions
# =============================================================================
# This file is sourced, not executed directly
# =============================================================================
#
# Description:
#   Fonctions utilitaires utilisées dans tout le projet : logging, validation,
#   détection système, etc.
#
# Dépendances:
#   - constants.sh (pour les couleurs)
#
# =============================================================================

# Source constants
# shellcheck source=constants.sh
source "$(dirname "${BASH_SOURCE[0]}")/constants.sh"

# -----------------------------------------------------------------------------
# Variables globales (set par detect_*)
# -----------------------------------------------------------------------------

VIBEBOX_OS=""
VIBEBOX_ARCH=""

# -----------------------------------------------------------------------------
# Fonctions de logging
# -----------------------------------------------------------------------------

# log_info <message>
#   Affiche un message d'information en bleu
log_info() {
    echo -e "${COLOR_BLUE}[vibebox]${COLOR_NC} $1"
}

# log_ok <message>
#   Affiche un message de succès en vert
log_ok() {
    echo -e "${COLOR_GREEN}[vibebox]${COLOR_NC} $1"
}

# log_warn <message>
#   Affiche un message d'avertissement en jaune
log_warn() {
    echo -e "${COLOR_YELLOW}[vibebox]${COLOR_NC} $1"
}

# log_error <message>
#   Affiche un message d'erreur en rouge
log_error() {
    echo -e "${COLOR_RED}[vibebox]${COLOR_NC} $1"
}

# -----------------------------------------------------------------------------
# Fonctions utilitaires
# -----------------------------------------------------------------------------

# require_command <cmd>
#   Vérifie qu'une commande existe, sinon log_error et exit 1
require_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        log_error "Required command not found: $cmd"
        exit 1
    fi
}

# detect_os
#   Détecte l'OS et stocke le résultat dans VIBEBOX_OS
#   Retourne "macos" ou "linux"
detect_os() {
    local os
    os="$(uname -s)"

    case "$os" in
        Darwin)
            VIBEBOX_OS="macos"
            ;;
        Linux)
            VIBEBOX_OS="linux"
            ;;
        *)
            VIBEBOX_OS="unknown"
            ;;
    esac

    echo "$VIBEBOX_OS"
}

# detect_arch
#   Détecte l'architecture et stocke le résultat dans VIBEBOX_ARCH
#   Retourne "arm64" ou "amd64"
detect_arch() {
    local arch
    arch="$(uname -m)"

    case "$arch" in
        aarch64|arm64)
            VIBEBOX_ARCH="arm64"
            ;;
        x86_64|amd64)
            VIBEBOX_ARCH="amd64"
            ;;
        *)
            VIBEBOX_ARCH="unknown"
            ;;
    esac

    echo "$VIBEBOX_ARCH"
}
