#!/bin/bash
# =========================================
# linux_security_check.sh
# =========================================

LOG_FILE="linux_security.json"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

while true; do
    log "Linux security check started"

    # Check required command
    if ! command -v grep >/dev/null; then
        log "ERROR: Required command 'grep' not available"
        exit 1
    fi

    # Check SSH log file
    if [ ! -f /var/log/auth.log ]; then
        log "ERROR: SSH log file not found"
        exit 1
    fi

    # Failed SSH login attempts
    FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | wc -l)
    log "Failed SSH login attempts: $FAILED_LOGINS"

    log "Linux security check completed successfully"

    # Wait 5 minutes before next iteration
    sleep 300
done
