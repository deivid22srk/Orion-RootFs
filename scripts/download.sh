#!/bin/bash
# Orion RootFS - Download Script
# Downloads all external assets for rootfs compilation

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCES_DIR="$ROOT_DIR/sources"
TEMP_DIR="$ROOT_DIR/temp"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Create directories
mkdir -p "$TEMP_DIR"
mkdir -p "$SOURCES_DIR"/{imagefs,proton}

# =============================================================================
# DOWNLOAD IMAGEFS (4 parts from GitLab)
# =============================================================================

download_imagefs() {
    log "Downloading ImageFS (4 parts)..."
    
    local BASE_URL="https://gitlab.com/winlator3/winlator-extra/-/raw/main/imagefs"
    local OUTPUT_FILE="$SOURCES_DIR/imagefs/imagefs.txz"
    
    # Check if already downloaded
    if [ -f "$OUTPUT_FILE" ]; then
        warn "ImageFS already exists, skipping download"
        return 0
    fi
    
    # Download all 4 parts
    for i in 0 1 2 3; do
        local part=$(printf "%02d" $i)
        local part_file="$TEMP_DIR/imagefs.txz.$part"
        local url="$BASE_URL/imagefs.txz.$part"
        
        log "  Downloading part $((i+1))/4: imagefs.txz.$part"
        
        if ! curl -fSL --retry 3 --retry-delay 5 -o "$part_file" "$url"; then
            error "Failed to download imagefs.txz.$part"
        fi
    done
    
    # Concatenate parts
    log "Merging ImageFS parts..."
    cat "$TEMP_DIR/imagefs.txz".* > "$OUTPUT_FILE"
    
    # Cleanup parts
    rm -f "$TEMP_DIR/imagefs.txz".*
    
    # Verify
    if [ -f "$OUTPUT_FILE" ]; then
        local size=$(du -h "$OUTPUT_FILE" | cut -f1)
        log "ImageFS downloaded successfully ($size)"
    else
        error "Failed to create imagefs.txz"
    fi
}

# =============================================================================
# DOWNLOAD PROTON
# =============================================================================

download_proton() {
    log "Downloading Proton 9.0 ARM64EC..."
    
    local BASE_URL="https://gitlab.com/winlator3/winlator-extra/-/raw/main/proton"
    local OUTPUT_FILE="$SOURCES_DIR/proton/proton-9.0-arm64ec.txz"
    
    # Check if already downloaded
    if [ -f "$OUTPUT_FILE" ]; then
        warn "Proton already exists, skipping download"
        return 0
    fi
    
    log "  Downloading proton-9.0-arm64ec.txz..."
    
    if ! curl -fSL --retry 3 --retry-delay 5 -o "$OUTPUT_FILE" "$BASE_URL/proton-9.0-arm64ec.txz"; then
        error "Failed to download proton-9.0-arm64ec.txz"
    fi
    
    # Verify
    if [ -f "$OUTPUT_FILE" ]; then
        local size=$(du -h "$OUTPUT_FILE" | cut -f1)
        log "Proton downloaded successfully ($size)"
    else
        error "Failed to download proton-9.0-arm64ec.txz"
    fi
}

# =============================================================================
# COPY EMBEDDED ASSETS
# =============================================================================

copy_embedded_assets() {
    log "Embedded assets already in repository"
    log "Skipping copy step"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    log "Orion RootFS Download Script"
    log "=============================="
    echo
    
    # Download external assets
    download_imagefs
    download_proton
    
    # Cleanup temp
    rm -rf "$TEMP_DIR"
    
    echo
    log "✅ Download complete!"
    log "All assets are in: $SOURCES_DIR"
}

# Run main function
main "$@"
