# Updated on 2023-08-11
#!/bin/bash
# System Backup Utility
BACKUP_DIR="/backup/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
echo "Backup created at $BACKUP_DIR"

