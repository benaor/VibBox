# =============================================================================
# VibBox - Docker Functions
# =============================================================================
# This file is sourced, not executed directly
# =============================================================================
#
# Description:
#   Fonctions pour interagir avec Docker : construction d'images, gestion des
#   conteneurs, vérification de l'état, etc.
#
# Dépendances:
#   - project.sh (qui source utils.sh et constants.sh)
#
# =============================================================================

# Source project (which sources utils and constants)
# shellcheck source=project.sh
source "$(dirname "${BASH_SOURCE[0]}")/project.sh"

# -----------------------------------------------------------------------------
# Fonctions
# -----------------------------------------------------------------------------

# ensure_docker - Verify Docker is installed and daemon is running
ensure_docker() {
    # Check if docker command exists
    if ! command -v docker &>/dev/null; then
        log_error "Docker is not installed"
        if [[ "$VIBEBOX_OS" == "macos" ]]; then
            log_error "Install Docker Desktop: https://docs.docker.com/desktop/install/mac-install/"
        else
            log_error "Install Docker: https://docs.docker.com/engine/install/"
        fi
        exit 1
    fi

    # Check if daemon is running
    if ! docker info &>/dev/null; then
        log_error "Docker daemon is not running"
        if [[ "$VIBEBOX_OS" == "macos" ]]; then
            log_error "Start Docker Desktop application"
        else
            log_error "Start docker service: sudo systemctl start docker"
        fi
        exit 1
    fi

    # On Linux, check if user is in docker group
    if [[ "$VIBEBOX_OS" == "linux" ]]; then
        if ! groups | grep -q '\bdocker\b'; then
            log_warn "Current user is not in the docker group"
            log_warn "Run: sudo usermod -aG docker $USER"
            log_warn "Then log out and log back in"
        fi
    fi
}

# image_exists - Check if the project image exists locally
image_exists() {
    docker image inspect "$IMAGE_NAME" &>/dev/null
}

# build_image - Build the VibBox Docker image for the current project
build_image() {
    log_info "Building VibBox image for project '$PROJECT_NAME'..."

    local dockerfile="$VIBEBOX_SOURCE_DIR/build/Dockerfile.base"

    if [[ ! -f "$dockerfile" ]]; then
        log_error "Dockerfile not found: $dockerfile"
        exit 1
    fi

    if docker build \
        --build-arg HOST_UID="$(id -u)" \
        --build-arg HOST_GID="$(id -g)" \
        -t "$IMAGE_NAME" \
        -f "$dockerfile" \
        "$VIBEBOX_SOURCE_DIR"; then
        log_ok "Image '$IMAGE_NAME' built successfully"
    else
        log_error "Failed to build image '$IMAGE_NAME'"
        exit 1
    fi
}

# remove_image - Remove the project Docker image
remove_image() {
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
    log_ok "Image '$IMAGE_NAME' removed"
}

# run_container <args...> - Run a VibBox container with optional arguments
run_container() {
    docker run \
        --rm \
        --name "$CONTAINER_NAME" \
        -it \
        -v "$(pwd):$WORKSPACE_MOUNT" \
        -v "$PROJECT_DATA_DIR/.vibe:/home/vibe/.vibe" \
        -v "$PROJECT_DATA_DIR/.zsh_history:/home/vibe/.zsh_history" \
        -e "MISTRAL_API_KEY=${MISTRAL_API_KEY:-}" \
        -e "TERM=${TERM:-xterm-256color}" \
        -w "$WORKSPACE_MOUNT" \
        "$IMAGE_NAME" \
        "$@"
}

# run_shell - Run a VibBox container with an interactive zsh shell
run_shell() {
    docker run \
        --rm \
        --name "$CONTAINER_NAME" \
        -it \
        -v "$(pwd):$WORKSPACE_MOUNT" \
        -v "$PROJECT_DATA_DIR/.vibe:/home/vibe/.vibe" \
        -v "$PROJECT_DATA_DIR/.zsh_history:/home/vibe/.zsh_history" \
        -e "MISTRAL_API_KEY=${MISTRAL_API_KEY:-}" \
        -e "TERM=${TERM:-xterm-256color}" \
        -w "$WORKSPACE_MOUNT" \
        --entrypoint /usr/bin/zsh \
        "$IMAGE_NAME"
}
