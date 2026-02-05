# =============================================================================
# VibBox - Project Management
# =============================================================================
# This file is sourced, not executed directly
# =============================================================================
#
# Description:
#   Fonctions pour la détection et la gestion des projets. Permet d'identifier
#   le projet courant, de gérer les répertoires de données et la configuration
#   par projet.
#
# Dépendances:
#   - utils.sh (qui source constants.sh)
#
# =============================================================================

# Source utils (which sources constants)
# shellcheck source=utils.sh
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# -----------------------------------------------------------------------------
# Variables globales (set par init_project_vars)
# -----------------------------------------------------------------------------

PROJECT_NAME=""
PROJECT_DATA_DIR=""
IMAGE_NAME=""
CONTAINER_NAME=""
PROJECT_PROFILES_FILE=""

# -----------------------------------------------------------------------------
# Fonctions
# -----------------------------------------------------------------------------

# get_project_name
#   Récupère le nom du projet basé sur le répertoire courant
#   - Prend le basename de $(pwd)
#   - Convertit en minuscules
#   - Remplace tout caractère non [a-z0-9_-] par un tiret
#   Return: nom du projet normalisé (stdout)
get_project_name() {
    local name
    name="$(basename "$(pwd)")"
    # Convert to lowercase and replace invalid chars with dash
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/-/g'
}

# init_project_vars
#   Initialise les variables globales du projet courant
#   Sets: PROJECT_NAME, PROJECT_DATA_DIR, IMAGE_NAME, CONTAINER_NAME, PROJECT_PROFILES_FILE
init_project_vars() {
    PROJECT_NAME="$(get_project_name)"
    PROJECT_DATA_DIR="$VIBEBOX_DIR/$PROJECT_NAME"
    IMAGE_NAME="${IMAGE_PREFIX}-${PROJECT_NAME}"
    CONTAINER_NAME="${CONTAINER_PREFIX}-${PROJECT_NAME}-$$"
    PROJECT_PROFILES_FILE="$VIBEBOX_DIR/profiles/${PROJECT_NAME}.ini"
}

# ensure_project_dirs
#   Crée les répertoires de données nécessaires pour le projet
#   - $PROJECT_DATA_DIR/.vibe/      (config vibe persistante)
#   - $PROJECT_DATA_DIR/.config/    (configs outils)
#   - $PROJECT_DATA_DIR/.zsh_history (historique shell)
#   - $VIBEBOX_DIR/profiles/        (répertoire des fichiers profils)
#   - $PROJECT_PROFILES_FILE        (fichier .ini du projet)
ensure_project_dirs() {
    local is_new_project=false

    # Check if this is a new project
    if [[ ! -d "$PROJECT_DATA_DIR" ]]; then
        is_new_project=true
    fi

    # Create project data directories
    mkdir -p "$PROJECT_DATA_DIR/.vibe"
    mkdir -p "$PROJECT_DATA_DIR/.config"

    # Create zsh_history file if it doesn't exist
    if [[ ! -f "$PROJECT_DATA_DIR/.zsh_history" ]]; then
        touch "$PROJECT_DATA_DIR/.zsh_history"
    fi

    # Create profiles directory
    mkdir -p "$VIBEBOX_DIR/profiles"

    # Create project profiles file if it doesn't exist
    if [[ ! -f "$PROJECT_PROFILES_FILE" ]]; then
        touch "$PROJECT_PROFILES_FILE"
    fi

    # Log if this is a new project
    if [[ "$is_new_project" == true ]]; then
        log_info "Project '$PROJECT_NAME' initialized"
    fi
}
