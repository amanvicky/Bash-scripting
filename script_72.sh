# Updated on 2023-08-23
#!/bin/bash
# Disk Usage Alert
THRESHOLD=80
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "Warning: Disk usage is above ${THRESHOLD}%"
fi

