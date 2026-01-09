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
    log "Copying embedded assets from app..."
    
    local APP_ASSETS="$ROOT_DIR/../GoWLauncher-Android/app/src/main/assets"
    
    if [ ! -d "$APP_ASSETS" ]; then
        warn "App assets directory not found: $APP_ASSETS"
        warn "Skipping embedded assets copy"
        return 0
    fi
    
    # Copy graphics drivers
    if [ -d "$APP_ASSETS/graphics_driver" ]; then
        log "  Copying graphics drivers..."
        cp -r "$APP_ASSETS/graphics_driver" "$SOURCES_DIR/"
    fi
    
    # Copy dxwrapper
    if [ -d "$APP_ASSETS/dxwrapper" ]; then
        log "  Copying dxwrapper..."
        cp -r "$APP_ASSETS/dxwrapper" "$SOURCES_DIR/"
    fi
    
    # Copy wincomponents
    if [ -d "$APP_ASSETS/wincomponents" ]; then
        log "  Copying wincomponents..."
        cp -r "$APP_ASSETS/wincomponents" "$SOURCES_DIR/"
    fi
    
    # Copy box64
    if [ -d "$APP_ASSETS/box64" ]; then
        log "  Copying box64..."
        cp -r "$APP_ASSETS/box64" "$SOURCES_DIR/"
    fi
    
    # Copy fexcore
    if [ -d "$APP_ASSETS/fexcore" ]; then
        log "  Copying fexcore..."
        cp -r "$APP_ASSETS/fexcore" "$SOURCES_DIR/"
    fi
    
    # Copy other files
    log "  Copying other assets..."
    mkdir -p "$SOURCES_DIR/others"
    
    for file in pulseaudio.tzst layers.tzst input_dlls.tzst container_pattern_common.tzst \
                proton-9.0-arm64ec_container_pattern.tzst proton-9.0-x86_64_container_pattern.tzst; do
        if [ -f "$APP_ASSETS/$file" ]; then
            cp "$APP_ASSETS/$file" "$SOURCES_DIR/others/"
        fi
    done
    
    # Copy ddrawrapper
    if [ -d "$APP_ASSETS/ddrawrapper" ]; then
        mkdir -p "$SOURCES_DIR/others/ddrawrapper"
        cp -r "$APP_ASSETS/ddrawrapper"/* "$SOURCES_DIR/others/ddrawrapper/"
    fi
    
    # Copy wowbox64
    if [ -d "$APP_ASSETS/wowbox64" ]; then
        mkdir -p "$SOURCES_DIR/others/wowbox64"
        cp -r "$APP_ASSETS/wowbox64"/* "$SOURCES_DIR/others/wowbox64/"
    fi
    
    # Copy soundfonts
    if [ -d "$APP_ASSETS/soundfonts" ]; then
        mkdir -p "$SOURCES_DIR/others/soundfonts"
        cp -r "$APP_ASSETS/soundfonts"/* "$SOURCES_DIR/others/soundfonts/"
    fi
    
    log "Embedded assets copied successfully"
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
    
    # Copy embedded assets (if available)
    copy_embedded_assets
    
    # Cleanup temp
    rm -rf "$TEMP_DIR"
    
    echo
    log "✅ Download complete!"
    log "All assets are in: $SOURCES_DIR"
}

# Run main function
main "$@"
