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

    export $(cut -d= -f1 "$CONF_FILE")


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
    trap 'FAILED_COMMAND="${BASH_COMMAND}"; FAILED_LINE="${BASH_LINENO[0]}"' ERR

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
        echo "Check $ERROR_OUTPUT for details." >&2
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
    ARGS=("$@")

    case "$COMMAND" in
        tests|action|perform|docker)
            SCRIPT="$BASE_DIR/$COMMAND/$SCRIPT_NAME.sh"
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

    (
        cd "$BASE_DIR"
        "$SCRIPT" "${ARGS[@]}"
    )

    log_success "$SCRIPT_NAME" "Script executed successfully"
EOF