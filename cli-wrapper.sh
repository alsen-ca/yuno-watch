#!/bin/bash
set -euo pipefail

NAME="yuno-watch"

sudo -u "$NAME" bash -s "$@" <<'EOF'
    echo ""
    set -euo pipefail
    CONF_FILE="/etc/yuno-watch/yuno-watch.conf"

    if [[ -f "$CONF_FILE" ]]; then
        source "$CONF_FILE"
    else
        echo "ERROR: $CONF_FILE not found" >&2
        exit 1
    fi

    for conf in "/etc/yuno-watch"/*.conf; do
        if [[ "$conf" != "$CONF_FILE" && -f "$conf" ]]; then
            source "$conf"
        fi
    done

    # Export all variables from configuration files
    while IFS= read -r var; do
        export "$var"
    done < <(compgen -v | grep -E '^[A-Z]')

    if [ ! -d "$BASE_DIR" ]; then
        echo "Error: YunoWatch installation not found at $BASE_DIR" >&2
        exit 1
    fi

    # At least 1 argument provided
    if [ $# -lt 1 ]; then
        echo "ERROR: Provide at least 1 argument"
        echo "Usage: yuno <command> [args...]"
        echo "Commands: tests, action, perform, docker"
        exit 1
    fi

    # Centralized logging
    FAILED_COMMAND=""
    FAILED_LINE=""

    timestamp() {
        date --iso-8601=seconds
    }
    log_success() {
        local custom_message="$1"
        printf "[%s] %s succeeded - %s\n" "$(timestamp)" "$SCRIPT_NAME" "$custom_message" >> "$SUCCESS_OUTPUT"
        echo "$SCRIPT_NAME.sh finished successfully"
    }
    log_failure() {
        local rc="$1"
        local custom_message="$2"
        local error_message=""

        if [[ -n "$FAILED_COMMAND" ]]; then
            error_message="Command: '$FAILED_COMMAND' (line $FAILED_LINE) failed."
        fi

        printf "[%s] %s FAILED (exit code %s) - %s %s\n" \
            "$(timestamp)" "$SCRIPT_NAME" "$rc" "$custom_message" "$error_message" >> "$ERROR_OUTPUT"
        echo "$(timestamp) $SCRIPT_NAME failed with exit code $rc. $error_message" >&2
        echo
    }
    log_info() {
        local custom_message="$1"
        printf "[%s] %s: %s\n" "$(timestamp)" "$SCRIPT_NAME" "$custom_message" >> "$SUCCESS_OUTPUT"
    }
    trap 'rc=$?; if (( rc != 0 )); then log_failure "$rc" "Script failed"; fi' EXIT

    # Extract the command and arguments
    COMMAND="$1"
    shift
    SCRIPT_NAME="$1"
    shift
    export SCRIPT_NAME

    case "$COMMAND" in
        test)
            SCRIPT="$BASE_DIR/$COMMAND/$SCRIPT_NAME.sh"
            if [ ! -f "$SCRIPT" ]; then
                echo "Error: Test script not found: $SCRIPT" >&2
                exit 1
            fi
            
            (
                export TERM=xterm-256color
                cd "$BASE_DIR"
                export SUCCESS_OUTPUT="${LOG_OUTPUT}/test.success.log"
                export ERROR_OUTPUT="${LOG_OUTPUT}/test.error.log"
                export ROTATION_SUB="$ROTATION_TEST"
                export SUMMARY_SUB="$SUMMARY_TEST"
                export NGINX_LOGS="$LOG_OUTPUT"
                "$SCRIPT"
            )
            ;;
        action|perform|docker)
            ARGS=("$@")
            trap 'FAILED_COMMAND="${BASH_COMMAND}"; FAILED_LINE="${BASH_LINENO[0]}"' ERR
            SCRIPT="$BASE_DIR/$COMMAND/$SCRIPT_NAME.sh"
            (
                cd "$BASE_DIR"
                "$SCRIPT" "${ARGS[@]}"
            )
            ;;
        *)
            echo "Error: Unknown command '$COMMAND'" >&2
            exit 1
            ;;
    esac

    if [ ! -f "$SCRIPT" ]; then
        echo "Error: Script not found: $SCRIPT" >&2
        exit 1
    fi

    log_success "$SCRIPT_NAME" "Script executed successfully"
EOF