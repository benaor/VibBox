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
# Variables globales (Ollama)
# -----------------------------------------------------------------------------

OLLAMA_AVAILABLE=false
OLLAMA_URL=""

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

# detect_ollama - Detect if Ollama is available (local or via OLLAMA_HOST)
detect_ollama() {
    OLLAMA_AVAILABLE=false
    OLLAMA_URL=""

    # If OLLAMA_HOST is explicitly set, use it
    if [[ -n "${OLLAMA_HOST:-}" ]]; then
        OLLAMA_URL="$OLLAMA_HOST"
        OLLAMA_AVAILABLE=true
        log_info "Ollama configured at $OLLAMA_URL"
        return 0
    fi

    # Try to detect local Ollama
    local test_url
    if [[ "$VIBEBOX_OS" == "macos" ]]; then
        # On macOS, host.docker.internal works natively with Docker Desktop
        test_url="http://localhost:11434/api/tags"
    else
        # On Linux, test localhost directly
        test_url="http://localhost:11434/api/tags"
    fi

    # Check if Ollama is running (with short timeout)
    if curl -s --connect-timeout 2 "$test_url" >/dev/null 2>&1; then
        # Ollama detected - set URL for container access
        # Both macOS and Linux will use host.docker.internal with --add-host
        OLLAMA_URL="http://host.docker.internal:11434"
        OLLAMA_AVAILABLE=true
        log_info "Ollama detected at $OLLAMA_URL"
        return 0
    fi

    return 1
}

# image_exists - Check if the project image exists locally
image_exists() {
    docker image inspect "$IMAGE_NAME" &>/dev/null
}

# build_image - Build the VibBox Docker image for the current project
build_image() {
    log_info "Building VibBox image for project '$PROJECT_NAME'..."
    log_info "This may take a few minutes on first run..."

    local dockerfile="$VIBEBOX_SOURCE_DIR/build/Dockerfile.base"
    local start_time
    start_time=$(date +%s)

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
        local end_time
        end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_ok "Image '$IMAGE_NAME' built successfully (${duration}s)"
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
    # Detect Ollama availability
    detect_ollama || true

    # Build docker run command
    local docker_args=(
        --rm
        --name "$CONTAINER_NAME"
        -it
        -v "$(pwd):$WORKSPACE_MOUNT"
        -v "$PROJECT_DATA_DIR/.vibe:/home/vibe/.vibe"
        -v "$PROJECT_DATA_DIR/.zsh_history:/home/vibe/.zsh_history"
        -e "MISTRAL_API_KEY=${MISTRAL_API_KEY:-}"
        -e "TERM=${TERM:-xterm-256color}"
        -w "$WORKSPACE_MOUNT"
    )

    # Add Ollama support if available
    if [[ "$OLLAMA_AVAILABLE" == true ]]; then
        docker_args+=(--add-host=host.docker.internal:host-gateway)
        docker_args+=(-e "OLLAMA_HOST=$OLLAMA_URL")
    fi

    docker run "${docker_args[@]}" "$IMAGE_NAME" "$@"
}

# run_shell - Run a VibBox container with an interactive zsh shell
run_shell() {
    # Detect Ollama availability
    detect_ollama || true

    # Build docker run command
    local docker_args=(
        --rm
        --name "$CONTAINER_NAME"
        -it
        -v "$(pwd):$WORKSPACE_MOUNT"
        -v "$PROJECT_DATA_DIR/.vibe:/home/vibe/.vibe"
        -v "$PROJECT_DATA_DIR/.zsh_history:/home/vibe/.zsh_history"
        -e "MISTRAL_API_KEY=${MISTRAL_API_KEY:-}"
        -e "TERM=${TERM:-xterm-256color}"
        -w "$WORKSPACE_MOUNT"
        --entrypoint /usr/bin/zsh
    )

    # Add Ollama support if available
    if [[ "$OLLAMA_AVAILABLE" == true ]]; then
        docker_args+=(--add-host=host.docker.internal:host-gateway)
        docker_args+=(-e "OLLAMA_HOST=$OLLAMA_URL")
    fi

    docker run "${docker_args[@]}" "$IMAGE_NAME"
}
