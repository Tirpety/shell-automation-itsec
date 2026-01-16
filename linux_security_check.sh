#!/bin/bash
# =========================================
# linux_security_check.sh
# Simple Linux security checks
# =========================================

LOG_FILE="linux_security.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log "Starting Linux security check"

# Check if required files exist
if [ ! -f /var/log/auth.log ]; then
    log "ERROR: auth.log not found"
    exit 1
fi

# Check for world-writable files
WW_FILES=$(find /etc -type f -perm -0002 2>/dev/null | wc -l)
log "World-writable files in /etc: $WW_FILES"

# Check failed SSH logins
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | wc -l)
log "Failed SSH logins: $FAILED_LOGINS"

log "Linux security check finished"
exit 0
