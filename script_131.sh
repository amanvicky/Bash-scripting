# Updated on 2023-10-10
#!/bin/bash
# Log Cleanup Script
LOG_DIR="/var/log/app"
find "$LOG_DIR" -type f -name "*.log" -mtime +30 -exec rm -f {} \;
echo "Old logs cleaned."

