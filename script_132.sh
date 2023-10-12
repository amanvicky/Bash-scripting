# Updated on 2023-10-12
#!/bin/bash
# Service Health Check
SERVICE="nginx"
if systemctl is-active --quiet "$SERVICE"; then
  echo "$SERVICE is running"
else
  echo "$SERVICE is down! Restarting..."
  systemctl start "$SERVICE"
fi

