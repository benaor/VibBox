#!/usr/bin/env bash
# =============================================================================
# VibBox Installer
# =============================================================================
#
# Install VibBox on macOS or Linux.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/TODO_GITHUB_USER/vibebox/main/install.sh | bash
#
# Or download and run:
#   ./install.sh
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

VIBEBOX_REPO="https://github.com/TODO_GITHUB_USER/vibebox.git"
VIBEBOX_DIR="$HOME/.vibebox"
VIBEBOX_SOURCE_DIR="$VIBEBOX_DIR/source"
VIBEBOX_BIN="$HOME/.local/bin/vibebox"

# -----------------------------------------------------------------------------
# Colors
# -----------------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[vibebox]${NC} $1"
}

log_ok() {
    echo -e "${GREEN}[vibebox]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[vibebox]${NC} $1"
}

log_error() {
    echo -e "${RED}[vibebox]${NC} $1"
}

# -----------------------------------------------------------------------------
# Banner
# -----------------------------------------------------------------------------

show_banner() {
    echo ""
    echo -e "${BOLD}╔═══════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║         VibBox Installer              ║${NC}"
    echo -e "${BOLD}║   Containerized Mistral Vibe CLI      ║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════╝${NC}"
    echo ""
}

# -----------------------------------------------------------------------------
# Checks
# -----------------------------------------------------------------------------

check_requirements() {
    log_info "Checking requirements..."

    # Check bash version (macOS has old bash 3.2, Linux usually 4+)
    local bash_major="${BASH_VERSION%%.*}"
    if [[ "$bash_major" -lt 3 ]]; then
        log_error "Bash 3.0+ is required (found: $BASH_VERSION)"
        exit 1
    fi

    # Check git
    if ! command -v git &>/dev/null; then
        log_error "git is required but not found"
        log_error "Install git: https://git-scm.com/downloads"
        exit 1
    fi

    # Check curl
    if ! command -v curl &>/dev/null; then
        log_error "curl is required but not found"
        exit 1
    fi

    log_ok "Requirements satisfied"
}

# -----------------------------------------------------------------------------
# Installation
# -----------------------------------------------------------------------------

clone_or_update() {
    if [[ -d "$VIBEBOX_SOURCE_DIR" ]]; then
        log_info "Updating VibBox..."
        cd "$VIBEBOX_SOURCE_DIR"
        git pull --quiet
        log_ok "VibBox updated"
    else
        log_info "Installing VibBox..."
        mkdir -p "$VIBEBOX_DIR"
        git clone --quiet "$VIBEBOX_REPO" "$VIBEBOX_SOURCE_DIR"
        log_ok "VibBox installed"
    fi
}

create_symlink() {
    log_info "Creating symlink..."

    # Create ~/.local/bin if it doesn't exist
    mkdir -p "$HOME/.local/bin"

    # Create symlink
    ln -sf "$VIBEBOX_SOURCE_DIR/vibebox" "$VIBEBOX_BIN"

    # Make executable
    chmod +x "$VIBEBOX_SOURCE_DIR/vibebox"

    log_ok "Symlink created: $VIBEBOX_BIN"
}

check_path() {
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo ""
        log_warn "\$HOME/.local/bin is not in your PATH"
        echo ""

        # Detect current shell
        local shell_name
        shell_name="$(basename "$SHELL")"

        echo "Add it to your shell configuration:"
        echo ""

        if [[ "$shell_name" == "zsh" ]]; then
            echo -e "  ${BOLD}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc${NC}"
            echo "  source ~/.zshrc"
        elif [[ "$shell_name" == "bash" ]]; then
            echo -e "  ${BOLD}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc${NC}"
            echo "  source ~/.bashrc"
        else
            echo "  For bash:"
            echo -e "    ${BOLD}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc${NC}"
            echo ""
            echo "  For zsh:"
            echo -e "    ${BOLD}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc${NC}"
        fi
        echo ""
    fi
}

check_docker() {
    if ! command -v docker &>/dev/null; then
        log_warn "Docker not found. VibBox will help you install it on first run."
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    show_banner
    check_requirements
    clone_or_update
    create_symlink
    check_path

    echo ""
    echo -e "✅ ${GREEN}${BOLD}VibBox installed!${NC} Run '${BOLD}vibebox help${NC}' to get started"
    echo ""

    check_docker
}

main "$@"
