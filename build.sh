#!/usr/bin/env bash
set -euo pipefail

# Configuration
CONFIG_FILE="${HOME}/.config/nix-system.conf"
CURRENT_HOSTNAME=$(hostname)
FLAKE_DIR="${FLAKE_DIR:-/etc/nixos}"
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RESET="\033[0m"

# Load or initialize default host
if [[ -f "$CONFIG_FILE" ]]; then
    DEFAULT_HOST=$(<"$CONFIG_FILE")
else
    DEFAULT_HOST="$CURRENT_HOSTNAME"
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo "$DEFAULT_HOST" > "$CONFIG_FILE"
fi

# Functions
show_help() {
    echo -e "${COLOR_GREEN}Usage: ${0} [command]${COLOR_RESET}"
    echo
    echo -e "${COLOR_YELLOW}Current Configuration:${COLOR_RESET}"
    echo -e "  Default host: ${COLOR_GREEN}${DEFAULT_HOST}${COLOR_RESET}"
    echo -e "  Flake dir:    ${COLOR_GREEN}${FLAKE_DIR}${COLOR_RESET}"
    echo -e "  System path:  ${COLOR_GREEN}${FLAKE_DIR}#${DEFAULT_HOST}${COLOR_RESET}"
    echo
    echo "Commands:"
    echo "  build [host]    - Build configuration (default: ${DEFAULT_HOST})"
    echo "  switch [host]   - Build/activate and set default host"
    echo "  update          - Update flake inputs"
    echo "  clean           - Remove old generations and delete garbage"
    echo "  gc              - Perform garbage collection"
    echo "  help            - Show this help"
    echo "  temp <app>      - Start shell with temporary application"
    echo "  run <app>       - Run app once wihtout installing"
    echo
    echo "Examples:"
    echo "  ${0} switch           # Use default host (${DEFAULT_HOST})"
    echo "  ${0} switch laptop    # Set 'laptop' as new default"
    echo "  ${0} build            # Build default host"
    echo "  ${0} update           # Update all flake inputs"
}

show_current_config() {
    echo -e "\n${COLOR_YELLOW}Active Configuration:${COLOR_RESET}"
    echo -e "  Hostname:  ${COLOR_GREEN}${CURRENT_HOSTNAME}${COLOR_RESET}"
    echo -e "  Default:   ${COLOR_GREEN}${DEFAULT_HOST}${COLOR_RESET}"
    echo -e "  Flake:     ${COLOR_GREEN}${FLAKE_DIR}${COLOR_RESET}"
    
    if [[ -d "${FLAKE_DIR}/.git" ]]; then
        echo -e "  Git repo:  ${COLOR_GREEN}$(git -C "$FLAKE_DIR" config --get remote.origin.url)${COLOR_RESET}"
    fi
    
    echo -e "  Modified:  ${COLOR_GREEN}$(stat -c %y "${FLAKE_DIR}/flake.nix" 2>/dev/null || echo 'Unknown')${COLOR_RESET}"
}

header() {
    echo -e "${COLOR_GREEN}▶${COLOR_RESET} ${COLOR_YELLOW}$1${COLOR_RESET}"
}

persist_default_host() {
    DEFAULT_HOST="$1"
    echo "$DEFAULT_HOST" > "$CONFIG_FILE"
    echo -e "${COLOR_GREEN}✓ New default host: ${DEFAULT_HOST}${COLOR_RESET}"
}

run_update() {
    local target="${1:-$DEFAULT_HOST}"
    header "Updating flake inputs"
    sudo nix flake update
}

run_build_switch() {
    local target="${1:-$DEFAULT_HOST}"
    header "Building system: ${target}"
    sudo nixos-rebuild switch --flake "${FLAKE_DIR}#${target}"
}

run_build_test() {
    local target="${1:-$DEFAULT_HOST}"
    header "Building system: ${target}"
    sudo nixos-rebuild test --flake "${FLAKE_DIR}#${target}"
}

run_build() {
    case "${1:-}" in
        switch)
            run_build_switch "${2:-$DEFAULT_HOST}"
	    ;;
	test)
	    run_build_test "${2:-$DEFAULT_HOST}"
	    ;;
	*)
	    run_build_switch "${2:-$DEFAULT_HOST}"
	    ;;
    esac
}

run_switch() {
    local target="${1:-$DEFAULT_HOST}"
    
    if [[ -n "${1:-}" ]]; then
        persist_default_host "$1"
        target="$1"
    fi

    header "Activating system: ${target}"
    sudo nixos-rebuild switch --flake "${FLAKE_DIR}#${target}"
}

run_clean() {
    header "Cleaning up..."
    sudo nix-collect-garbage --delete-older-than 7d
    sudo nix-store --optimise
}

run_gc() {
    header "Performing garbage collection"
    sudo nix-store --gc
}

run_temp() {
    local app="${1:?Please specify an application}"
    header "Starting temporary shell with ${app}"
    echo -e "${COLOR_YELLOW}Type 'exit' to leave the temporary environment${COLOR_RESET}"
    nix shell --impure "nixpkgs#${app}"
}

run_app() {
    local app="${1:?Please specify an application}"
    header "Running ${app} temporarily"
    nix run --impure "nixpkgs#${app}"
}

# Main command parsing
case "${1:-}" in
    build)
        run_build "${2:-}" "${3:-}"
        ;;
    switch)
        run_switch "${2:-}"
        ;;
    update)
        run_update "${2:-}"
        ;;
    clean)
        run_clean
        ;;
    gc)
        run_gc
        ;;
    help|--help|-h|"")
        show_help
        show_current_config
        ;;
    temp)
        run_temp "${2:-}"
        ;;
    run)
        run_app "${2:-}"
        ;;
    *)
        echo -e "${COLOR_RED}Unknown command: $1${COLOR_RESET}"
        show_help
        exit 1
        ;;

esac
