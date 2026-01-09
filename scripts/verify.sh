#!/bin/bash
# Orion RootFS - Verify Script
# Verifies integrity of compiled .orfs package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$ROOT_DIR/output"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# =============================================================================
# VERIFY CHECKSUM
# =============================================================================

verify_checksum() {
    log "Verifying package checksum..."
    
    local orfs_file="$1"
    local orfs_basename=$(basename "$orfs_file" .orfs)
    local sha_file="$(dirname "$orfs_file")/${orfs_basename}.sha256"
    
    if [ ! -f "$orfs_file" ]; then
        error "Package file not found: $orfs_file"
    fi
    
    if [ ! -f "$sha_file" ]; then
        error "Checksum file not found: $sha_file"
    fi
    
    cd "$(dirname "$orfs_file")"
    
    if sha256sum -c "$(basename "$sha_file")" 2>/dev/null; then
        log "✓ Checksum verification PASSED"
        return 0
    else
        error "✗ Checksum verification FAILED"
        return 1
    fi
}

# =============================================================================
# VERIFY STRUCTURE
# =============================================================================

verify_structure() {
    log "Verifying package structure..."
    
    local orfs_file="$1"
    local temp_dir="$ROOT_DIR/temp/verify"
    
    # Extract to temp
    mkdir -p "$temp_dir"
    tar -xf "$orfs_file" -C "$temp_dir" --use-compress-program=unzstd
    
    # Check required files
    local required_files=(
        "rootfs/metadata.json"
        "rootfs/imagefs/imagefs.txz"
        "rootfs/proton/proton-9.0-arm64ec.txz"
    )
    
    local missing=0
    for file in "${required_files[@]}"; do
        if [ ! -f "$temp_dir/$file" ]; then
            error "Missing required file: $file"
            missing=1
        fi
    done
    
    # Cleanup
    rm -rf "$temp_dir"
    
    if [ $missing -eq 0 ]; then
        log "✓ Structure verification PASSED"
        return 0
    else
        error "✗ Structure verification FAILED"
        return 1
    fi
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    log "Orion RootFS Verification"
    log "=========================="
    echo
    
    # Find latest .orfs file
    local orfs_file=$(ls -t "$OUTPUT_DIR"/*.orfs 2>/dev/null | head -1)
    
    if [ -z "$orfs_file" ]; then
        error "No .orfs file found in output directory"
    fi
    
    log "Verifying: $(basename "$orfs_file")"
    echo
    
    # Run verifications
    verify_checksum "$orfs_file"
    verify_structure "$orfs_file"
    
    echo
    log "========================================="
    log "✅ VERIFICATION COMPLETE - ALL CHECKS PASSED"
    log "========================================="
}

# Run main
main "$@"
