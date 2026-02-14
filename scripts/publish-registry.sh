#!/bin/bash
# Archon.Social Registry Publisher
# Publishes the current name registry to IPFS and updates IPNS
# Run via cron: 0 */4 * * * /path/to/publish-registry.sh

set -e

# Configuration
REGISTRY_URL="${REGISTRY_URL:-https://archon.social/api/registry}"
IPNS_KEY="${IPNS_KEY:-self}"
ARCHON_DIR="${ARCHON_DIR:-$HOME/archon}"
LOG_FILE="${LOG_FILE:-/var/log/archon-social-publish.log}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting registry publish..."

# Fetch current registry
REGISTRY_JSON=$(curl -s "$REGISTRY_URL")
if [ -z "$REGISTRY_JSON" ]; then
    log "ERROR: Failed to fetch registry from $REGISTRY_URL"
    exit 1
fi

# Count names
NAME_COUNT=$(echo "$REGISTRY_JSON" | jq '.names | length')
log "Registry contains $NAME_COUNT names"

# Add to IPFS via docker
cd "$ARCHON_DIR"
CID=$(echo "$REGISTRY_JSON" | docker compose exec -T ipfs ipfs add -q --pin=true)

if [ -z "$CID" ]; then
    log "ERROR: Failed to add registry to IPFS"
    exit 1
fi

log "Added to IPFS: $CID"

# Publish to IPNS
IPNS_RESULT=$(docker compose exec -T ipfs ipfs name publish --key="$IPNS_KEY" "/ipfs/$CID" 2>&1)

if echo "$IPNS_RESULT" | grep -q "Published"; then
    IPNS_NAME=$(echo "$IPNS_RESULT" | grep -oP 'Published to \K[^:]+')
    log "Published to IPNS: $IPNS_NAME"
    log "SUCCESS: Registry published"
else
    log "ERROR: IPNS publish failed: $IPNS_RESULT"
    exit 1
fi
