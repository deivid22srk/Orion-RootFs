#!/bin/bash
# Orion RootFS - Compile Script
# Compiles all assets into a single .orfs package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCES_DIR="$ROOT_DIR/sources"
OUTPUT_DIR="$ROOT_DIR/output"
TEMP_DIR="$ROOT_DIR/temp/build"

VERSION="1.0.0"
OUTPUT_FILE="$OUTPUT_DIR/orion-rootfs-v$VERSION.orfs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

progress() {
    echo -e "${BLUE}[PROGRESS]${NC} $1"
}

# =============================================================================
# VERIFY SOURCES
# =============================================================================

verify_sources() {
    log "Verifying source files..."
    
    local missing=0
    
    # Check imagefs
    if [ ! -f "$SOURCES_DIR/imagefs/imagefs.txz" ]; then
        error "Missing: imagefs/imagefs.txz"
        missing=1
    fi
    
    # Check proton
    if [ ! -f "$SOURCES_DIR/proton/proton-9.0-arm64ec.txz" ]; then
        error "Missing: proton/proton-9.0-arm64ec.txz"
        missing=1
    fi
    
    if [ $missing -eq 1 ]; then
        error "Missing required source files. Run download.sh first."
    fi
    
    log "All required sources present ✓"
}

# =============================================================================
# PREPARE BUILD DIRECTORY
# =============================================================================

prepare_build() {
    log "Preparing build directory..."
    
    # Clean and create directories
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR/rootfs"
    mkdir -p "$OUTPUT_DIR"
    
    log "Build directory prepared"
}

# =============================================================================
# ORGANIZE ASSETS
# =============================================================================

organize_assets() {
    log "Organizing assets..."
    
    local rootfs="$TEMP_DIR/rootfs"
    
    # Create structure
    mkdir -p "$rootfs"/{imagefs,proton,graphics_driver,dxwrapper,wincomponents,box64,fexcore,others}
    
    # Copy core files
    progress "Copying ImageFS..."
    cp "$SOURCES_DIR/imagefs/imagefs.txz" "$rootfs/imagefs/"
    
    progress "Copying Proton..."
    cp "$SOURCES_DIR/proton/proton-9.0-arm64ec.txz" "$rootfs/proton/"
    
    # Copy graphics drivers (if exists)
    if [ -d "$SOURCES_DIR/graphics_driver" ]; then
        progress "Copying graphics drivers..."
        cp -r "$SOURCES_DIR/graphics_driver"/* "$rootfs/graphics_driver/" 2>/dev/null || true
    fi
    
    # Copy dxwrapper (if exists)
    if [ -d "$SOURCES_DIR/dxwrapper" ]; then
        progress "Copying dxwrapper..."
        cp -r "$SOURCES_DIR/dxwrapper"/* "$rootfs/dxwrapper/" 2>/dev/null || true
    fi
    
    # Copy wincomponents (if exists)
    if [ -d "$SOURCES_DIR/wincomponents" ]; then
        progress "Copying wincomponents..."
        cp -r "$SOURCES_DIR/wincomponents"/* "$rootfs/wincomponents/" 2>/dev/null || true
    fi
    
    # Copy box64 (if exists)
    if [ -d "$SOURCES_DIR/box64" ]; then
        progress "Copying box64..."
        cp -r "$SOURCES_DIR/box64"/* "$rootfs/box64/" 2>/dev/null || true
    fi
    
    # Copy fexcore (if exists)
    if [ -d "$SOURCES_DIR/fexcore" ]; then
        progress "Copying fexcore..."
        cp -r "$SOURCES_DIR/fexcore"/* "$rootfs/fexcore/" 2>/dev/null || true
    fi
    
    # Copy others (if exists)
    if [ -d "$SOURCES_DIR/others" ]; then
        progress "Copying other assets..."
        cp -r "$SOURCES_DIR/others"/* "$rootfs/others/" 2>/dev/null || true
    fi
    
    log "Assets organized ✓"
}

# =============================================================================
# CREATE METADATA
# =============================================================================

create_metadata() {
    log "Creating metadata..."
    
    local rootfs="$TEMP_DIR/rootfs"
    local metadata="$rootfs/metadata.json"
    
    # Get file sizes and checksums
    local imagefs_size=$(du -h "$rootfs/imagefs/imagefs.txz" | cut -f1)
    local imagefs_sha=$(sha256sum "$rootfs/imagefs/imagefs.txz" | cut -d' ' -f1)
    
    local proton_size=$(du -h "$rootfs/proton/proton-9.0-arm64ec.txz" | cut -f1)
    local proton_sha=$(sha256sum "$rootfs/proton/proton-9.0-arm64ec.txz" | cut -d' ' -f1)
    
    # Create metadata JSON
    cat > "$metadata" << EOF
{
  "version": "$VERSION",
  "build_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "imagefs_version": 21,
  "wine_version": "proton-9.0-arm64ec",
  
  "files": [
    {
      "name": "imagefs/imagefs.txz",
      "size": "$imagefs_size",
      "sha256": "$imagefs_sha"
    },
    {
      "name": "proton/proton-9.0-arm64ec.txz",
      "size": "$proton_size",
      "sha256": "$proton_sha"
    }
  ],
  
  "components": [
    "imagefs",
    "proton",
    "graphics_driver",
    "dxwrapper",
    "wincomponents",
    "box64",
    "fexcore",
    "others"
  ],
  
  "requirements": {
    "android_version": "8.0+",
    "api_level": 26,
    "architecture": "arm64-v8a",
    "min_storage": "5GB",
    "recommended_ram": "4GB"
  }
}
EOF
    
    log "Metadata created ✓"
}

# =============================================================================
# COMPRESS ROOTFS
# =============================================================================

compress_rootfs() {
    log "Compressing RootFS package..."
    
    local rootfs="$TEMP_DIR/rootfs"
    
    progress "Creating .orfs archive (this may take several minutes)..."
    
    # Use tar with zstd compression
    cd "$TEMP_DIR"
    tar -cf - rootfs/ | zstd -19 -T0 > "$OUTPUT_FILE"
    
    if [ ! -f "$OUTPUT_FILE" ]; then
        error "Failed to create .orfs file"
    fi
    
    local size=$(du -h "$OUTPUT_FILE" | cut -f1)
    log "RootFS package created: $size ✓"
}

# =============================================================================
# CREATE CHECKSUM
# =============================================================================

create_checksum() {
    log "Creating checksum..."
    
    cd "$OUTPUT_DIR"
    sha256sum "orion-rootfs-v$VERSION.orfs" > "orion-rootfs-v$VERSION.sha256"
    
    log "Checksum created ✓"
}

# =============================================================================
# CLEANUP
# =============================================================================

cleanup() {
    log "Cleaning up temporary files..."
    
    rm -rf "$TEMP_DIR"
    
    log "Cleanup complete ✓"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    log "Orion RootFS Compile Script"
    log "============================="
    log "Version: $VERSION"
    echo
    
    # Run build steps
    verify_sources
    prepare_build
    organize_assets
    create_metadata
    compress_rootfs
    create_checksum
    cleanup
    
    echo
    log "========================================="
    log "✅ BUILD COMPLETE!"
    log "========================================="
    log "Output file: $OUTPUT_FILE"
    log "Size: $(du -h "$OUTPUT_FILE" | cut -f1)"
    log "Checksum: $OUTPUT_DIR/orion-rootfs-v$VERSION.sha256"
    echo
    log "You can now upload this to GitHub Releases"
}

# Run main
main "$@"
