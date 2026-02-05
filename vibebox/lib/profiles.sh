# =============================================================================
# VibBox - Profile System
# =============================================================================
# This file is sourced, not executed directly
# =============================================================================
#
# Description:
#   Système de gestion des profils. Permet d'installer, lister et vérifier
#   le statut des profils de développement (TypeScript, PHP, etc.).
#
# Profiles are stored in: $VIBEBOX_SOURCE_DIR/build/profiles/*.sh
# Installed profiles tracked in: $PROJECT_PROFILES_FILE (one profile name per line)
#
# Dépendances:
#   - docker.sh (qui source project.sh, utils.sh, constants.sh)
#
# =============================================================================

# Source docker (which sources project, utils, and constants)
# shellcheck source=docker.sh
source "$(dirname "${BASH_SOURCE[0]}")/docker.sh"

# -----------------------------------------------------------------------------
# Fonctions
# -----------------------------------------------------------------------------

# list_profiles - List all available profiles and their status
list_profiles() {
    local profiles_dir="$VIBEBOX_SOURCE_DIR/build/profiles"
    local installed_profiles=""

    # Read installed profiles if file exists
    if [[ -f "$PROJECT_PROFILES_FILE" ]]; then
        installed_profiles="$(cat "$PROJECT_PROFILES_FILE")"
    fi

    echo "Available profiles:"
    echo ""

    # Scan for profile scripts
    for profile_script in "$profiles_dir"/*.sh; do
        if [[ -f "$profile_script" ]]; then
            local profile_name
            profile_name="$(basename "$profile_script" .sh)"

            # Check if installed
            if echo "$installed_profiles" | grep -q "^${profile_name}$"; then
                printf "  %-15s ${COLOR_GREEN}[installed]${COLOR_NC}\n" "$profile_name"
            else
                printf "  %-15s ${COLOR_CYAN}[available]${COLOR_NC}\n" "$profile_name"
            fi
        fi
    done

    echo ""
}

# profile_status - Show installed profiles for current project
profile_status() {
    if [[ ! -f "$PROJECT_PROFILES_FILE" ]] || [[ ! -s "$PROJECT_PROFILES_FILE" ]]; then
        log_info "No profiles installed for '$PROJECT_NAME'"
        return
    fi

    echo "Installed profiles for '$PROJECT_NAME':"
    echo ""
    while IFS= read -r profile; do
        echo "  - $profile"
    done < "$PROJECT_PROFILES_FILE"
    echo ""
}

# install_profile <profile_name> - Install a profile into the project image
install_profile() {
    local profile_name="$1"
    local profile_script="$VIBEBOX_SOURCE_DIR/build/profiles/${profile_name}.sh"
    # Use profile name, PID and timestamp for unique container name (prevents race conditions)
    local temp_container="vibebox-profile-${profile_name}-$$-$(date +%s)"

    # Check if profile exists
    if [[ ! -f "$profile_script" ]]; then
        log_error "Profile '$profile_name' not found"
        echo ""
        list_profiles
        return 1
    fi

    # Check if already installed
    if [[ -f "$PROJECT_PROFILES_FILE" ]] && grep -q "^${profile_name}$" "$PROJECT_PROFILES_FILE"; then
        log_warn "Profile '$profile_name' is already installed"
        return 0
    fi

    # Ensure image exists
    if ! image_exists; then
        log_info "Image not found, building first..."
        build_image
    fi

    log_info "Installing profile '$profile_name'..."

    # Cleanup function
    cleanup_temp_container() {
        docker rm -f "$temp_container" &>/dev/null || true
    }

    # Ensure cleanup on exit
    trap cleanup_temp_container EXIT

    # Start temporary container
    docker run -d \
        --name "$temp_container" \
        --entrypoint sleep \
        "$IMAGE_NAME" \
        3600 >/dev/null

    # Copy profile script into container
    docker cp "$profile_script" "$temp_container:/tmp/install-profile.sh"

    # Execute profile script
    if docker exec "$temp_container" bash /tmp/install-profile.sh; then
        # Commit changes to image
        docker commit "$temp_container" "$IMAGE_NAME" >/dev/null

        # Record profile as installed
        echo "$profile_name" >> "$PROJECT_PROFILES_FILE"

        log_ok "Profile '$profile_name' installed"
    else
        log_error "Failed to install profile '$profile_name'"
        cleanup_temp_container
        trap - EXIT
        return 1
    fi

    # Cleanup
    cleanup_temp_container
    trap - EXIT
}

# handle_profile <args...> - Handle profile subcommands
handle_profile() {
    local cmd="${1:-status}"

    case "$cmd" in
        status)
            profile_status
            ;;
        *)
            # Install one or more profiles
            for profile in "$@"; do
                install_profile "$profile"
            done
            ;;
    esac
}
